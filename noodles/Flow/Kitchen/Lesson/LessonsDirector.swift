//
//  LessonsDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

protocol LessonSaveImplementation {
}

protocol ModelRefreshable {
	associatedtype TModel

	func refresh(_ model: TModel)
}

class LessonsDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {
	typealias AudioPlayerType = AudioPlayer

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
		let director = LessonPhrasesDirector(router: self.router)
		let viewController = director.makeViewController(lesson)
		router.push(viewController, onDismiss: nil)
	}
}

extension LessonsDirector : LessonsListViewControlDelegate {

	func delete(_ lesson: Model.Recipe, _ refresh: (() -> Void)?) {

		FileUtils.delete(lesson.id)
		refresh?()
	}
}

extension LessonSaveImplementation {
	func save(_ lesson: Model.Recipe) {
		FileUtils.makePhraseDirectory(lesson.id)
		lesson.save()
	}
}
