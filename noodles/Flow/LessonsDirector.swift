//
//  LessonsDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class LessonsDirector: DefaultDirector, AudioPlayerImplementation {

	var players: [URL: AudioPlayer] = [:]
}

extension LessonsDirector : LessonsListViewFlowDelegate {

	func openInbox() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Inbox"])
		NotificationCenter.default.post(notification)
	}

	func openPhrases() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Phrases"])
		NotificationCenter.default.post(notification)
	}

	func openLesson(_ lesson: Model.Recipe?) {
		let lesson = lesson ?? Model.Recipe(id: FileUtils.getNewLessonId())
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "lesson.phrases", creator: { (coder: NSCoder) -> LessonPhrasesViewController? in
			return LessonPhrasesViewController(coder: coder, flow: self, lesson: lesson)
		})
		router.push(inboxViewController, onDismiss: nil)
	}
}

extension LessonsDirector : LessonPhrasesViewFlowDelegate {

	func openMusicPage() {
	}


	func openExportPage() {
	}
}

extension LessonsDirector : LessonPhrasesViewControlDelegate {

	func selectPhrases(for lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "lesson.phraseSelector", creator: { (coder: NSCoder) -> LessonPhraseSelectorViewController? in
			return LessonPhraseSelectorViewController(coder: coder, flow: self, lesson: lesson, confirm: refresh)
		})
		router.push(inboxViewController, onDismiss: nil)
	}


	func createPhrase(for lesson: Model.Recipe, _ refresh: @escaping (Model.Recipe) -> Void) {
		let phraseId = FileUtils.getNewPhraseId()
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let phraseEditDelegate = PhrasesDirector(router: self.router)!
		let editViewController = storyboard.instantiateViewController(identifier: "phrase.edit", creator: { (coder: NSCoder) -> PhraseEditViewController? in
			return PhraseEditViewController(coder: coder, flow: phraseEditDelegate, content: Model.Phrase(id: phraseId), applyHandle: { (phrase: Model.Phrase?) -> Void in

				FileUtils.makePhraseDirectory(phraseId)
				phrase?.save()
			})
		})
		router.push(editViewController, onDismiss: {
			var newLesson = lesson
			newLesson.addPhrase(id: phraseId)
			refresh(newLesson)
		})
	}


	func play(phrase: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, result: ((Bool) -> Void)?) {

		let phrase = Model.Phrase(id: phrase)
		let shape = Shape(dna: Settings.language.preferBase ? "AB" : "BA")
		let noodle = Model.Noodle(phrase: phrase, shape: shape)
		playAudio(noodle, progress: progress, finish: result)
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


	func save(_ lesson: Model.Recipe) {
		FileUtils.makePhraseDirectory(lesson.id)
		lesson.save()
	}
}

extension LessonsDirector: LessonPhraseSelectorViewFlowDelegate {
}

extension LessonsDirector: LessonPhraseSelectorViewControlDelegate {

	func confirm(_ lesson: Model.Recipe, _ confirm: (Model.Recipe) -> Void) {
		save(lesson)
		confirm(lesson)
		router.pop(animated: true)
	}
}
