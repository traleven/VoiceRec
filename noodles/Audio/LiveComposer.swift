//
//  LiveComposer.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import Foundation
import MediaPlayer

class LiveComposer: Composer, AudioPlayerImplementation {
	typealias AudioPlayerType = LongformAudioPlayer

	var players: [URL : AudioPlayer] = [:]
	private(set) var isPlaying: Bool = false

	open func play(_ lesson: @escaping LessonProvider) {

		DispatchQueue.main.async {
			self.isPlaying = true
			self.playMusic(lesson)
			self.playPhrase(lesson)
		}
	}

	func updateVolume(_ lesson: Model.Recipe) {

		let spices = lesson.spices
		let voice = spices.voiceVolume
		let music = spices.musicVolume
		if let musicUrl = lesson.music, let musicPlayer = players[musicUrl] {

			musicPlayer.setVolume(music, fadeDuration: 0.1)
		}
		for kvp in players.filter({ $0.key != lesson.music }) {
			kvp.value.setVolume(voice, fadeDuration: 0.1)
		}
	}

	private func playMusic(_ lessonProvider: @escaping LessonProvider) {
		guard isPlaying else { return }

		let lesson = lessonProvider()
		if let music = lesson.music {
			self.playAudio(music, volume: lesson.spices.musicVolume, progress: nil) { [weak self] (result: PlayerResult) in
				guard result == .finished else { return }
				DispatchQueue.main.async {
					self?.playMusic(lessonProvider)
				}
			}
		}
	}

	private func playPhrase(_ lessonProvider: @escaping LessonProvider) {
		guard  isPlaying else { return }

		let lesson = lessonProvider()
		let idx = lesson.spices.randomize ? Int.random(in: 0 ..< lesson.phraseCount) : 0
		playPhrase(lessonProvider, idx: idx)
	}

	private func playPhrase(_ lessonProvider: @escaping LessonProvider, idx: Int) {
		guard isPlaying else { return }

		let lesson = lessonProvider()
		let delay = Double(lesson.spices.delayBetween)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak self] in
			guard let self = self, self.isPlaying else { return }

			let lesson = lessonProvider()
			let spices = lesson.spices
			let phrase = Model.Phrase(id: lesson[idx % lesson.phraseCount])
			let noodle = Model.Noodle(phrase: phrase, shape: lesson.shape)
			self.playAudio(noodle, with: spices.delayWithin, volume: spices.voiceVolume, progress: nil) { [weak self] (result: PlayerResult) in

				let lesson = lessonProvider()
				let spices = lesson.spices
				let random = spices.randomize
				let next = random ? Int.random(in: 0 ..< lesson.phraseCount) : lesson.index(after: idx)
				self?.playPhrase(lessonProvider, idx: next)
			}
		}
	}

	open func stop() {

		isPlaying = false
		self.stopPlayingAll()
	}
}
