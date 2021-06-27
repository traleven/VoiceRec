//
//  ExportComposer.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 23.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import MediaPlayer

class ExportComposer : Composer {

	var audioMix: AVAudioMix?

	private func tryPlay(_ noodle: Model.Noodle, spices: Spices, into compositionTrack: AVMutableCompositionTrack, at:CMTime, before:CMTime, preferredTimescale: CMTimeScale) -> Bool {

		var position = at.isValid
			? at + CMTime(seconds: spices.delayBetweenInterval + spices.delayWithinInterval, preferredTimescale: at.timescale)
			: CMTime(seconds: spices.delayBetweenInterval, preferredTimescale: preferredTimescale)

		for phrase in noodle {

			let newAsset = AVURLAsset(url: phrase)
			if position.seconds + newAsset.duration.seconds + spices.delayWithinInterval > before.seconds {
				return false
			}

			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! compositionTrack.insertTimeRange(range, of: track, at: position)
			}
			position = position + CMTime(seconds: spices.delayWithinInterval, preferredTimescale: position.timescale)
			position = position + newAsset.duration

		}
		return true
	}


	private func compose(_ lesson: Model.Recipe) -> AVComposition {

		let composition = AVMutableComposition()
		let audioMix: AVMutableAudioMix = AVMutableAudioMix()
		var audioMixParam: [AVMutableAudioMixInputParameters] = []

		let musicTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

		if let audioUrl = lesson.music {

			let newAsset = AVURLAsset(url: audioUrl)
			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
			let end = musicTrack.timeRange.end
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! musicTrack.insertTimeRange(range, of: track, at: end)
			}
		}

		let voiceTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID:kCMPersistentTrackID_Invalid)!

		let bowl = Model.Bowl(lesson: lesson)
		for phrase in bowl {
			let endOfVoice = voiceTrack.timeRange.end
			let endOfMusic = musicTrack.timeRange.end
			if !tryPlay(phrase,
				spices: lesson.spices,
				into: voiceTrack,
				at: endOfVoice,
				before: endOfMusic,
				preferredTimescale: endOfMusic.timescale
			) {
				break
			}
		}

		let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: musicTrack)
		musicParam.trackID = musicTrack.trackID
		musicParam.setVolume(lesson.spices.musicVolume, at: CMTime.zero)
		let voiceParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: voiceTrack)
		voiceParam.trackID = voiceTrack.trackID
		voiceParam.setVolume(lesson.spices.voiceVolume, at: CMTime.zero)

		audioMixParam.append(musicParam)
		audioMixParam.append(voiceParam)
		audioMix.inputParameters = audioMixParam

		self.audioMix = audioMix
		return composition
	}

	func export(lesson: Model.Recipe, completionHandler: @escaping (URL, Error?) -> Void) {
		guard  lesson.music != nil else { fatalError() }

		let resultFile = FileUtils.getTempFile(withExtension: "m4a")

		let assetExport = AVAssetExportSession(asset: self.compose(lesson), presetName: AVAssetExportPresetAppleM4A)!
		assetExport.shouldOptimizeForNetworkUse = true
		assetExport.audioMix = self.audioMix
		assetExport.outputFileType = AVFileType.m4a
		assetExport.outputURL = resultFile

		assetExport.exportAsynchronously(completionHandler: {
			completionHandler(resultFile, assetExport.error)
		})
	}
}
