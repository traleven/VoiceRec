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


	func play(language: String, then: @escaping () -> Void) {

		player = AudioPlayer(language == "English" ? english : chinese)
		player?.play(onProgress: { (_ : TimeInterval, _ : TimeInterval) in
		}, onFinish: { self.wait(forInterval: 1, then: then) })
	}


	func playSequence(then: @escaping () -> Void) {

		play(sequence: DB.phrases.getValue(forKey: phrase), then: then)
	}


	func play(sequence: String, then: @escaping () -> Void) {

		play(sequence: ArraySlice(Array<Character>(sequence)), then: then)
	}


	func play(sequence: ArraySlice<Character>, then: @escaping () -> Void) {

		if (sequence.count > 0) {
			self.play(language: sequence[sequence.startIndex] == "E" ? "English" : "Chinese") {
				self.play(sequence: sequence[(sequence.startIndex+1)...], then: then)
			}
		} else {
			wait(forInterval: 3, then: then)
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


	func tryPlayInto(_ compositionTrack: AVMutableCompositionTrack, at:CMTime, before:CMTime) -> Bool {

		let sequence = Array(DB.phrases.getValue(forKey: phrase))
		var position = at + CMTime(seconds: 3, preferredTimescale: at.timescale)
		for code in sequence {

			let newAsset = AVURLAsset(url: code == "E" ? english : chinese)
			if position.seconds + newAsset.duration.seconds > before.seconds {
				return false
			}

			let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! compositionTrack.insertTimeRange(range, of: track, at: position)
			}
			position = position + CMTime(seconds: 1, preferredTimescale: position.timescale)
			position = position + newAsset.duration

		}
		return true
	}
}
