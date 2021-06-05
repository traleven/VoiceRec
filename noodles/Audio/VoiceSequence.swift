//
//  VoiceSequence.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import MediaPlayer

class VoiceSequence: NSObject {

	var phrase: String

	var player: AudioPlayer?
	var timer: Timer?
	var volume: Float = 1.0

	init(withPhrase: String) {

		phrase = withPhrase
	}


	func tryPlayInto(_ compositionTrack: AVMutableCompositionTrack, at:CMTime, before:CMTime) -> Bool {

//		let native = VoiceSequence.buildVoiceURL(phrase, language: Settings.language.base)
//		let foreign = VoiceSequence.buildVoiceURL(phrase, language: Settings.language.target)
//
//		let sequence = Array(DB.phrases.getValue(forKey: phrase))
//		var position = at + CMTime(seconds: Settings.phrase.delay.outer, preferredTimescale: at.timescale)
//		for code in sequence {
//
//			let newAsset = AVURLAsset(url: code == "N" || code == "E" ? native : foreign)
//			if position.seconds + newAsset.duration.seconds > before.seconds {
//				return false
//			}
//
//			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
//			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
//				try! compositionTrack.insertTimeRange(range, of: track, at: position)
//			}
//			position = position + CMTime(seconds: Settings.phrase.delay.inner, preferredTimescale: position.timescale)
//			position = position + newAsset.duration
//
//		}
		return true
	}
}
