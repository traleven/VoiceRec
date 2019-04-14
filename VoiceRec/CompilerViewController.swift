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

		musicVolumeSlider.value = Settings.music.volume
		voiceVolumeSlider.value = Settings.voice.volume
		phraseInnerDelaySlider.value = Float(Settings.phrase.delay.inner)
		phraseOuterDelaySlider.value = Float(Settings.phrase.delay.outer)
		phraseRandomSwitch.isOn = Settings.phrase.random
	}


	@IBAction func playTheThing(_ sender: UIButton) {

		if (musicPlayer?.isPlaying ?? false) {
			voiceTimer?.invalidate()
			musicPlayer.stop(silent: true)
			phrase.stop()
			sender.setTitle("Play", for: .normal)
			UIApplication.shared.isIdleTimerDisabled = false
		} else {
			prepare_data()
			voiceIdx = -1
			playMusic()
			playVoice()
			sender.setTitle("Stop", for: .normal)
			UIApplication.shared.isIdleTimerDisabled = true
		}
	}


	func prepare_data() {

		music = DB.music.getKeys(withValue: "y")
		voice = DB.phrases.getKeysWithValue()
		voice.sort()
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
		}) {(_ success: Bool) in
			self.playMusic()
		}
		musicPlayer.audioPlayer?.volume = Settings.music.volume
	}


	func playVoice() {

		phrase = VoiceSequence(withPhrase: nextPhrase())
		phrase.playSequence() { (_ success: Bool) in
			if !success {
				DB.phrases.setValue(forKey: self.phrase.phrase, value: "")
			}
			self.playVoice()
		}
		phrase.volume = Settings.voice.volume
	}


	var voiceIdx = -1
	func nextPhrase() -> String {

		if (Settings.phrase.random) {
			return voice.getRandom()!
		} else {
			voiceIdx = (voiceIdx + 1) % voice.count
			return voice[voiceIdx]
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
		})
	}


	@IBAction func onMusicVolumeChanged(_ sender: UISlider) {

		Settings.music.volume = sender.value
		musicPlayer.audioPlayer?.volume = sender.value
	}


	@IBAction func onVoiceVolumeChanged(_ sender: UISlider) {

		Settings.voice.volume = sender.value
		phrase.volume = sender.value
	}


	@IBAction func onOuterDelayChanged(_ sender: UISlider) {

		Settings.phrase.delay.outer = Double(sender.value)
	}


	@IBAction func onInnerDelayChanged(_ sender: UISlider) {

		Settings.phrase.delay.inner = Double(sender.value)
	}


	@IBAction func onPhraseRandomizationChanged(_ sender: UISwitch) {

		Settings.phrase.random = sender.isOn
	}
}
