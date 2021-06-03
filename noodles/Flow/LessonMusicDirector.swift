//
//  LessonMusicDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class LessonsMusicDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {

	var players: [URL: AudioPlayer] = [:]

	func makeViewController(lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) -> UIViewController {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "lesson.musicSelector", creator: { (coder: NSCoder) -> LessonMusicViewController? in
			return LessonMusicViewController(coder: coder, flow: self, lesson: lesson, confirm: confirm)
		})
		return viewController
	}
}

extension LessonsMusicDirector: LessonMusicViewFlowDelegate {
	func openPhrases(_ lesson: Model.Recipe) {

		router.pop(animated: true)
	}

	func openExport(_ lesson: Model.Recipe) {

		print("go to lesson export page (not implemented yet)")
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

	func play(_ phrase: Model.Phrase, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {

		let noodle = Model.Noodle(phrase: phrase, shape: Shape(dna: "AB"))
		playAudio(noodle, at: phrase.id, progress: progress, finish: finish)
	}

	func stop(_ phrase: Model.Phrase) {

		_ = stopPlaying(phrase.id)
	}

	func stopAllAudio() {
		
		self.stopPlayingAll()
	}
}
