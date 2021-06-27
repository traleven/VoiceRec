//
//  LessonPhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class LessonPhrasesDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {
	typealias AudioPlayerType = AudioPlayer

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(_ lesson: Model.Recipe) -> UIViewController {
		
		let storyboard = getStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.phrases", creator: { (coder: NSCoder) -> LessonPhrasesViewController? in
			return LessonPhrasesViewController(coder: coder, flow: self, lesson: lesson)
		})
		return viewController
	}
}

extension LessonPhrasesDirector : LessonPhrasesViewFlowDelegate {

	func openMusicPage(_ lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) -> Bool {

		if lesson.contains(where: { !Model.Phrase(id: $0).isComplete }) {
			return false
		}

		let director = LessonsMusicDirector(router: router)
		let tuple = director.makeViewController(lesson: lesson, confirm: refresh)
		router.push(tuple.0, onDismiss: nil)
		return true
	}


	func openExportPage(_ lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) -> Bool {
		
		if lesson.contains(where: { !Model.Phrase(id: $0).isComplete }) {
			return false
		}

		let director = LessonsMusicDirector(router: router)
		let tuple = director.makeViewController(lesson: lesson, confirm: refresh)
		router.push(tuple.0, onDismiss: nil)

		director.openExport(lesson, tuple.1)
		return true
	}


	func openPhrasePage(_ phrase: Model.Phrase, _ refresh: RefreshHandle?) {

		let director = PhraseEditDirector(router: router)
		let viewController = director.makeViewController(phrase: phrase) { (result: Model.Phrase?) in
			result?.save()
			refresh?()
		}

		router.push(viewController, onDismiss: nil)
	}
}

extension LessonPhrasesDirector : LessonPhrasesViewControlDelegate {

	func selectPhrases(for lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) {

		let director = LessonsPhraseSelectorDirector(router: self.router)
		let viewController = director.makeViewController(lesson: lesson, confirm: refresh)
		router.push(viewController, onDismiss: nil)
	}


	func createPhrase(for lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) {

		let phraseId = FileUtils.getNewPhraseId()
		let director = PhraseEditDirector(router: self.router)
		let viewController = director.makeViewController(phrase: Model.Phrase(id: phraseId), confirm: { (phrase: Model.Phrase?) -> Void in
			FileUtils.makePhraseDirectory(phraseId)
			phrase?.save()
		})
		router.push(viewController, onDismiss: {
			var newLesson = lesson
			newLesson.addPhrase(id: phraseId)
			refresh(newLesson)
		})
	}


	func play(phrase: URL, of shape: Shape, with spices: Spices, progress: PlayerProgressCallback?, result: PlayerResultCallback?) {

		let phrase = Model.Phrase(id: phrase)
		let noodle = Model.Noodle(phrase: phrase, shape: shape)
		_ = playAudio(noodle, with: spices.delayWithin, volume: spices.voiceVolume, progress: progress, finish: result)
	}


	func startLivePreview(_ lesson: Model.Recipe, with spices: Spices, _ onFinish: @escaping () -> Void) {

		if let music = lesson.music {
			self.playAudio(music, volume: spices.musicVolume, progress: nil, finish: { _ in onFinish() })
		}
	}


	func stopLivePreview(_ lesson: Model.Recipe) {

		if let music = lesson.music {
			let _ = self.stopPlaying(music)
		}
	}


	func remove(phrase: URL, from lesson: Model.Recipe, _ refresh: (Model.Recipe) -> Void) {

		var newLesson = lesson
		newLesson.removePhrase(id: phrase)
		refresh(newLesson)
	}
}
