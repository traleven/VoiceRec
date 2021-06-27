//
//  LessonExportDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 04.06.21.
//

import UIKit

class LessonExportDirector: DefaultDirector, LessonSaveImplementation {

	var players: [URL: AudioPlayer] = [:]
	var composer: LiveComposer = LiveComposer()

	func makeViewController(lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) -> UIViewController {
		let storyboard = getStoryboard(name: "Kitchen", bundle: nil)
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

	func selectRepetitionPattern(_ lesson: Model.Recipe, _ refresh: ((Model.Recipe) -> Void)?) {

		let director = PatternSelectionDirector(router: router)
		let viewController = director.makeViewController(current: lesson.shape, confirm: { (result: Shape) in
			var newLesson = lesson
			newLesson.shape = result
			self.router.dismiss(animated: true, completion: {
				refresh?(newLesson)
			})
		})
		router.present(viewController, onDismiss: nil)
	}

	func updateLivePreviewSettings(_ lesson: Model.Recipe) {

		composer.updateVolume(lesson)
	}

	func startLivePreview(_ lesson: @escaping () -> Model.Recipe) {

		composer.stop()
		composer.play(lesson)
	}

	func stopLivePreview() {

		if composer.isPlaying {
			composer.stop()
		}
	}

	func bake(_ lesson: Model.Recipe) {

		let storyboard = getStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.cooking")
		router.present(viewController, onDismiss: nil)

		let queue = OperationQueue()
		queue.addOperation {
			let root = FileUtils.getDirectory(.cooked)
			let target = root.appendingPathComponent(lesson.id.lastPathComponent)
			FileUtils.delete(target)
			lesson.save(to: target)
			if let music = lesson.music {
				let musicRoot = target.appendingPathComponent(FileUtils.Directories.music.rawValue, isDirectory: true)
				_ = FileUtils.copy(music, to: musicRoot)
			}
			let phrasesRoot = target.appendingPathComponent(FileUtils.Directories.phrases.rawValue, isDirectory: true)
			for phrase in lesson {
				_ = FileUtils.copy(phrase, to: phrasesRoot)
			}
			DispatchQueue.runOnMain {
				self.router.dismiss(animated: true, completion: {
					self.router.popToRoot(animated: true)
				})
			}
		}
	}
}
