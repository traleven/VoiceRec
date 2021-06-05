//
//  LessonPhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class LessonPhrasesDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(_ lesson: Model.Recipe) -> UIViewController {
		
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
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


	func play(phrase: URL, of shape: Shape, with spices: Spices, progress: PlayerProgressCallback?, result: ((Bool) -> Void)?) {

		let phrase = Model.Phrase(id: phrase)
		let noodle = Model.Noodle(phrase: phrase, shape: shape)
		playAudio(noodle, with: spices.delayWithin, progress: progress, finish: result)
	}


	func startLivePreview(_ lesson: Model.Recipe, _ onFinish: @escaping () -> Void) {

		if let music = lesson.music {
			self.playAudio(music, progress: nil, finish: { _ in onFinish() })
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
