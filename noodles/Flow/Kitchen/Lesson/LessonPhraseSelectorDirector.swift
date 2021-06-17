//
//  LessonPhraseSelectorDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class LessonsPhraseSelectorDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {
	typealias AudioPlayerType = AudioPlayer

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(lesson: Model.Recipe, confirm: @escaping (Model.Recipe) -> Void) -> UIViewController {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.phraseSelector", creator: { (coder: NSCoder) -> LessonPhraseSelectorViewController? in
			return LessonPhraseSelectorViewController(coder: coder, flow: self, lesson: lesson, confirm: confirm)
		})
		return viewController
	}
}

extension LessonsPhraseSelectorDirector: LessonPhraseSelectorViewFlowDelegate {
}

extension LessonsPhraseSelectorDirector: LessonPhraseSelectorViewControlDelegate {
	func confirm(_ lesson: Model.Recipe, _ confirm: (Model.Recipe) -> Void) {
		save(lesson)
		confirm(lesson)
		router.pop(animated: true)
	}
}
