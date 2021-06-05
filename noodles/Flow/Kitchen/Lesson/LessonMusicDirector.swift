//
//  LessonMusicDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class LessonsMusicDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) -> (UIViewController, ((Model.Recipe) -> Void)?) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.musicSelector", creator: { (coder: NSCoder) -> LessonMusicViewController? in
			return LessonMusicViewController(coder: coder, flow: self, lesson: lesson, confirm: confirm)
		})
		return (viewController, viewController.refresh(_:))
	}
}

extension LessonsMusicDirector: LessonMusicViewFlowDelegate {
	func openPhrases(_ lesson: Model.Recipe) {

		router.pop(animated: true)
	}

	func openExport(_ lesson: Model.Recipe, _ refresh: ((Model.Recipe) -> Void)?) {

		let director = LessonExportDirector(router: router)
		let viewController = director.makeViewController(lesson: lesson, confirm: refresh)
		router.push(viewController, onDismiss: nil)
	}

}

extension LessonsMusicDirector: LessonMusicViewControlDelegate {
	func selectMusic(_ url: URL, for lesson: Model.Recipe, _ refresh: (Model.Recipe) -> Void) {

		var newLesson = lesson
		newLesson.music = url
		refresh(newLesson)
	}

	func playMusic(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {

		playAudio(url, at: FileUtils.getDirectory(.music), progress: progress, finish: finish)
	}

	func stopMusic() {

		_ = stopPlaying(FileUtils.getDirectory(.music))
	}

	func play(_ phrase: Model.Phrase, of shape: Shape, with spices: Spices, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {

		let noodle = Model.Noodle(phrase: phrase, shape: shape)
		playAudio(noodle, at: phrase.id, with: spices.delayWithin, progress: progress, finish: finish)
	}

	func stop(_ phrase: Model.Phrase) {

		_ = stopPlaying(phrase.id)
	}

	func stopAllAudio() {
		
		self.stopPlayingAll()
	}
}
