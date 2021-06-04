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


	class func buildVoiceURL(_ forKey: String, language: Language) -> URL {

		return FileUtils.getDirectory("recordings")
			.appendingPathComponent(forKey)
			.appendingPathComponent(language.code.appending(".m4a"))
	}


	func play(language: Language, then: @escaping (Bool) -> Void) {

		player = AudioPlayer(VoiceSequence.buildVoiceURL(phrase, language: language))
		player?.play(onProgress: { (_ : TimeInterval, _ : TimeInterval) in
		}, onFinish: {
			(_ success: Bool) in
			if success {
				self.wait(forInterval: TimeInterval(Settings.phrase.delay.inner), then: {then(true)})
			} else {
				then(false)
			}
		})
		player?.audioPlayer?.volume = volume
	}


	func playSequence(then: @escaping (Bool) -> Void) {

		NSLog("Play \(phrase)")
		//play(sequence: DB.phrases.getValue(forKey: phrase), then: then)
	}


	func play(sequence: String, then: @escaping (Bool) -> Void) {

		play(sequence: ArraySlice(Array<Character>(sequence)), then: then)
	}


	func play(sequence: ArraySlice<Character>, then: @escaping (Bool) -> Void) {

		if (sequence.count > 0) {
			self.play(language: Settings.language.getLanguage(sequence[sequence.startIndex])) {
				(_ success: Bool) in
				if success {
					self.play(sequence: sequence[(sequence.startIndex+1)...], then: then)
				} else {
					then(false)
				}
			}
		} else {
			wait(forInterval: TimeInterval(Settings.phrase.delay.outer), then: { then(true) })
		}
	}


	func wait(forInterval: TimeInterval, then: @escaping () -> Void) {

		timer?.invalidate()
		timer = Timer(timeInterval: forInterval, repeats: false, block: { (timer: Timer) in
			timer.invalidate()
			self.timer = nil
			then()
		})
		RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.default)
	}


	func stop() {

		player?.stop(silent: true)
		timer?.invalidate()
		timer = nil
	}


	func setVolume(_ volume: Float) {

		self.volume = volume
		player?.audioPlayer?.volume = volume
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
