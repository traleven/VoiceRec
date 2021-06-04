//
//  LessonExportDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 04.06.21.
//

import UIKit

class LessonExportDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) -> UIViewController {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.export", creator: { (coder: NSCoder) -> LessonExportViewController? in
			return LessonExportViewController(coder: coder, flow: self, lesson: lesson, confirm: confirm)
		})
		return viewController
	}
}

extension LessonExportDirector: LessonExportViewFlowDelegate {

	func openPhrasesPage(_ lesson: Model.Recipe) {

		router.pop(animated: true)
		router.pop(animated: true)
	}

	func openMusicPage(_ lesson: Model.Recipe) {

		router.pop(animated: true)
	}
}

extension LessonExportDirector: LessonExportViewControlDelegate {

	func startLivePreview(_ lesson: Model.Recipe, finish: (() -> Void)?) {
	}

	func stopLivePreview(_ lesson: Model.Recipe) {
	}

	func stopAllAudio() {

		self.stopPlayingAll()
	}
}
