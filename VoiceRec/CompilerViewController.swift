//
//  CompilerViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import MediaPlayer

class CompilerViewController: UIViewController {

	@IBOutlet var activityIndicator: UIActivityIndicatorView!

	@IBOutlet var musicVolumeSlider: UISlider!
	@IBOutlet var voiceVolumeSlider: UISlider!
	@IBOutlet var phraseOuterDelaySlider: UISlider!
	@IBOutlet var phraseInnerDelaySlider: UISlider!
	@IBOutlet var phraseRandomSwitch: UISwitch!

	var musicPlayer: AudioPlayer!
	var phrase: VoiceSequence!

	var music: [String] = [String]()
	var voice: [String] = [String]()

	var voiceTimer: Timer!

	override func viewDidLoad() {
		super.viewDidLoad()

		musicVolumeSlider.value = DB.settings.float(forKey: "music.volume")
		voiceVolumeSlider.value = DB.settings.float(forKey: "voice.volume")
		phraseInnerDelaySlider.value = Float(DB.settings.double(forKey: "phrase.delay.inner"))
		phraseOuterDelaySlider.value = Float(DB.settings.double(forKey: "phrase.delay.outer"))
		phraseRandomSwitch.isOn = DB.settings.bool(forKey: "phrase.random")
	}


	@IBAction func playTheThing(_ sender: UIButton) {

		if (musicPlayer?.isPlaying ?? false) {
			voiceTimer?.invalidate()
			musicPlayer.stop(silent: true)
			phrase.stop()
			sender.setTitle("Play", for: .normal)
		} else {
			prepare_data()
			playMusic()
			playVoice()
			sender.setTitle("Stop", for: .normal)
		}
	}


	func prepare_data() {

		music = DB.music.getKeys(withValue: "y")
		voice = DB.phrases.getKeysWithValue()
	}


	func buildMusicURL(_ forKey: String) -> URL {

		return FileUtils.getDirectory("music").appendingPathComponent(forKey)
	}


	func buildMusicURLs(_ filenames: [String]) -> [URL] {

		var result = [URL]()
		for filename in filenames {
			result.append(buildMusicURL(filename))
		}
		return result
	}


	func playMusic() {

		musicPlayer = AudioPlayer(buildMusicURL(music.getRandom()!))
		musicPlayer.play(onProgress: { (_: TimeInterval, _: TimeInterval) in
		}) {
			self.playMusic()
		}
	}


	func playVoice() {

		phrase = VoiceSequence(withPhrase: voice.getRandom()!)
		phrase.playSequence() {
			self.playVoice()
		}
	}


	@IBAction func export() {

		activityIndicator.startAnimating()

		prepare_data()

		let composer = ExportComposer(withMusic: buildMusicURLs(music), andPhrases: voice)

		let resultFileName = Date().description + ".m4a"
		let destinationUrl = FileUtils.getDirectory("export").appendingPathComponent(resultFileName)
		do { try FileManager.default.removeItem(at: destinationUrl) } catch {}

		let assetExport = AVAssetExportSession(asset: composer.compose(), presetName: AVAssetExportPresetAppleM4A)!
		assetExport.shouldOptimizeForNetworkUse = true
		assetExport.audioMix = composer.audioMix
		assetExport.outputFileType = AVFileType.m4a
		assetExport.outputURL = destinationUrl

		assetExport.exportAsynchronously(completionHandler: {
			DispatchQueue.main.async {
				self.activityIndicator.stopAnimating()
				UIUtils.display_alert(at_view_controller: self, msg_title: "Mixture export: ".appending(assetExport.error?.localizedDescription ?? "OK"), msg_desc: "Export complete to: ".appending(destinationUrl.path), action_title: "OK")
			}
			//NSLog("Supported formats: %@", assetExport.supportedFileTypes)
		})
	}


	@IBAction func onMusicVolumeChanged(_ sender: UISlider) {

		DB.settings.set(sender.value, forKey: "music.volume")
	}


	@IBAction func onVoiceVolumeChanged(_ sender: UISlider) {

		DB.settings.set(sender.value, forKey: "voice.volume")
	}


	@IBAction func onOuterDelayChanged(_ sender: UISlider) {

		DB.settings.set(Double(sender.value), forKey: "phrase.delay.outer")
	}


	@IBAction func onInnerDelayChanged(_ sender: UISlider) {

		DB.settings.set(Double(sender.value), forKey: "phrase.delay.inner")
	}


	@IBAction func onPhraseRandomizationChanged(_ sender: UISwitch) {

		DB.settings.set(sender.isOn, forKey: "phrase.random")
	}
}


class ExportComposer : NSObject {

	var music: [URL]
	var phrases: [String]
	var audioMix: AVAudioMix?

	init(withMusic:[URL], andPhrases: [String]) {

		music = withMusic
		phrases = andPhrases
	}

	func compose() -> AVComposition {

		let composition = AVMutableComposition()
		let audioMix: AVMutableAudioMix = AVMutableAudioMix()
		var audioMixParam: [AVMutableAudioMixInputParameters] = []

		let musicTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

		for audioUrl in music.shuffled() {

			let newAsset = AVURLAsset(url: audioUrl)
			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
			let end = musicTrack.timeRange.end
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! musicTrack.insertTimeRange(range, of: track, at: end)
			}
		}

		let voiceTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

		var phrase: VoiceSequence
		repeat {
			phrase = VoiceSequence(withPhrase: phrases.getRandom()!)
		} while phrase.tryPlayInto(voiceTrack, at:voiceTrack.timeRange.end, before:musicTrack.timeRange.end)
		voiceTrack.preferredVolume = DB.settings.float(forKey: "voice.volume")

		let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: musicTrack)
		musicParam.trackID = musicTrack.trackID
		musicParam.setVolume(DB.settings.float(forKey: "music.volume"), at: CMTime.zero)
		let voiceParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: voiceTrack)
		voiceParam.trackID = voiceTrack.trackID
		voiceParam.setVolume(DB.settings.float(forKey: "voice.volume"), at: CMTime.zero)

		audioMixParam.append(musicParam)
		audioMixParam.append(voiceParam)
		audioMix.inputParameters = audioMixParam

		self.audioMix = audioMix
		return composition
	}
}

extension Array  {

	func getRandom() -> Element? {

		if (self.count > 0) {
			let count = self.count
			return self[Int.random(in: 0...count-1)]
		}
		return nil
	}
}
