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
	var english: URL
	var chinese: URL

	var player: AudioPlayer?
	var timer: Timer?
	var volume: Float = 1.0

	init(withPhrase: String) {

		phrase = withPhrase
		english = VoiceSequence.buildVoiceURL(withPhrase, language: "English")
		chinese = VoiceSequence.buildVoiceURL(withPhrase, language: "Chinese")
	}


	class func buildVoiceURL(_ forKey: String, language: String) -> URL {

		return FileUtils.getDirectory("recordings")
			.appendingPathComponent(forKey)
			.appendingPathComponent(language.appending(".m4a"))
	}


	func play(language: String, then: @escaping (Bool) -> Void) {

		player = AudioPlayer(language == "English" ? english : chinese)
		player?.play(onProgress: { (_ : TimeInterval, _ : TimeInterval) in
		}, onFinish: {
			(_ success: Bool) in
			if success {
				self.wait(forInterval: Settings.phrase.delay.inner, then: {then(true)})
			} else {
				then(false)
			}
		})
		player?.audioPlayer?.volume = volume
	}


	func playSequence(then: @escaping (Bool) -> Void) {

		NSLog("Play \(phrase)")
		play(sequence: DB.phrases.getValue(forKey: phrase), then: then)
	}


	func play(sequence: String, then: @escaping (Bool) -> Void) {

		play(sequence: ArraySlice(Array<Character>(sequence)), then: then)
	}


	func play(sequence: ArraySlice<Character>, then: @escaping (Bool) -> Void) {

		if (sequence.count > 0) {
			self.play(language: sequence[sequence.startIndex] == "E" ? "English" : "Chinese") {
				(_ success: Bool) in
				if success {
					self.play(sequence: sequence[(sequence.startIndex+1)...], then: then)
				} else {
					then(false)
				}
			}
		} else {
			wait(forInterval: Settings.phrase.delay.outer, then: { then(false) })
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

		let sequence = Array(DB.phrases.getValue(forKey: phrase))
		var position = at + CMTime(seconds: Settings.phrase.delay.outer, preferredTimescale: at.timescale)
		for code in sequence {

			let newAsset = AVURLAsset(url: code == "E" ? english : chinese)
			if position.seconds + newAsset.duration.seconds > before.seconds {
				return false
			}

			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! compositionTrack.insertTimeRange(range, of: track, at: position)
			}
			position = position + CMTime(seconds: Settings.phrase.delay.inner, preferredTimescale: position.timescale)
			position = position + newAsset.duration

		}
		return true
	}
}
