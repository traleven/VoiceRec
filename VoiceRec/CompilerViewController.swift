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

	var musicPlayer: AudioPlayer!
	var phrase: VoiceSequence!

	var music: [String] = [String]()
	var voice: [String] = [String]()

	var voiceTimer: Timer!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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


	func getRandom(fromArray: [String]) -> String {

		if (fromArray.count > 0) {
			let count = fromArray.count
			return fromArray[Int.random(in: 0...count-1)]
		}
		return ""
	}


	func playMusic() {

		musicPlayer = AudioPlayer(buildMusicURL(getRandom(fromArray: music)))
		musicPlayer.play(onProgress: { (_: TimeInterval, _: TimeInterval) in
		}) {
			self.playMusic()
		}
	}


	func playVoice() {

		let phraseKey = getRandom(fromArray: voice)
		phrase = VoiceSequence(withPhrase: phraseKey)
		phrase.play(sequence: DB.phrases.getValue(forKey: phraseKey)) {
			self.playVoice()
		}
	}


	func merge(audioUrls: [URL]) {

		//Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
		let composition = AVMutableComposition()


		//create new file to receive data
		//let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
		let resultNameWithExtension = "test.m4a"//Date().description + ".m4a"
		let fileDestinationUrl = FileUtils.getDirectory("export").appendingPathComponent(resultNameWithExtension)
		FileManager.default.createFile(atPath: fileDestinationUrl.path, contents: nil)
		do { try FileManager.default.removeItem(at: fileDestinationUrl) } catch {}
		//print(fileDestinationUrl)

		var avAssets: [AVURLAsset] = []
		var assetTracks: [AVAssetTrack] = []
		var timeRanges: [CMTimeRange] = []

		for audioUrl in audioUrls {
			let compositionAudioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

			let avAsset = AVURLAsset(url: audioUrl, options: nil)
			avAssets.append(avAsset)

			let assetTrack = avAsset.tracks(withMediaType: AVMediaType.audio)
			assetTracks.append(contentsOf: assetTrack)

			let duration = assetTrack[0].timeRange.duration
			let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
			timeRanges.append(timeRange)

			NSLog("Input %d tracks from %@", assetTrack.count, audioUrl.lastPathComponent)
			do {
				try compositionAudioTrack.insertTimeRange(timeRange, of: assetTrack[0], at: CMTime.zero)
			} catch let error as NSError {
				print("compositionAudioTrack insert error: \(error)")
			}
		}

		let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
		assetExport.shouldOptimizeForNetworkUse = true
		assetExport.outputFileType = AVFileType.m4a
		assetExport.outputURL = fileDestinationUrl
		assetExport.exportAsynchronously(completionHandler: {
			DispatchQueue.main.async {
				UIUtils.display_alert(at_view_controller: self, msg_title: "Mixture export: ".appending(assetExport.error?.localizedDescription ?? "OK"), msg_desc: "Export complete to: ".appending(fileDestinationUrl.path), action_title: "OK")
			}
			//NSLog("Supported formats: %@", assetExport.supportedFileTypes)
		})
	}
}
