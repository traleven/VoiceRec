//
//  ExportComposer.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 23.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import MediaPlayer

class ExportComposer : NSObject {

	var music: [URL]
	var phrases: [String]
	var audioMix: AVAudioMix?

	init(withMusic:[URL], andPhrases: [String]) {

		music = withMusic
		phrases = andPhrases
	}


	var phraseIdx = -1
	func nextPhrase() -> String {

		if (Settings.phrase.random) {
			return phrases.getRandom()!
		} else {
			phraseIdx = (phraseIdx + 1) % phrases.count
			return phrases[phraseIdx]
		}
	}


	func compose() -> AVComposition {

		phraseIdx = -1
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
			phrase = VoiceSequence(withPhrase: nextPhrase())
		} while phrase.tryPlayInto(voiceTrack, at:voiceTrack.timeRange.end, before:musicTrack.timeRange.end)

		let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: musicTrack)
		musicParam.trackID = musicTrack.trackID
		musicParam.setVolume(Settings.music.volume, at: CMTime.zero)
		let voiceParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: voiceTrack)
		voiceParam.trackID = voiceTrack.trackID
		voiceParam.setVolume(Settings.voice.volume, at: CMTime.zero)

		audioMixParam.append(musicParam)
		audioMixParam.append(voiceParam)
		audioMix.inputParameters = audioMixParam

		self.audioMix = audioMix
		return composition
	}
}

//@IBAction func export() {
//
//	activityIndicator.startAnimating()
//
//	prepare_data()
//
//	let composer = ExportComposer(withMusic: buildMusicURLs(music), andPhrases: voice)
//
//	let resultFileName = Date().description + ".m4a"
//	let destinationUrl = FileUtils.getDirectory("export").appendingPathComponent(resultFileName)
//	do { try FileManager.default.removeItem(at: destinationUrl) } catch {}
//
//	let assetExport = AVAssetExportSession(asset: composer.compose(), presetName: AVAssetExportPresetAppleM4A)!
//	assetExport.shouldOptimizeForNetworkUse = true
//	assetExport.audioMix = composer.audioMix
//	assetExport.outputFileType = AVFileType.m4a
//	assetExport.outputURL = destinationUrl
//
//	assetExport.exportAsynchronously(completionHandler: {
//		DispatchQueue.main.async {
//			self.activityIndicator.stopAnimating()
//			UIUtils.display_alert(at_view_controller: self, msg_title: "Mixture export: ".appending(assetExport.error?.localizedDescription ?? "OK"), msg_desc: "Export complete to: ".appending(destinationUrl.path), action_title: "OK")
//		}
//	})
//}
