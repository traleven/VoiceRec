//
//  LessonPlayerDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit

class LessonPlayerDirector : DefaultDirector {
	var players: [URL: AudioPlayer] = [:]
	var composer: LiveComposer = LiveComposer()
	var lessonTimer: Timer?
}

extension LessonPlayerDirector : LessonPlayerViewFlowDelegate {
}

extension LessonPlayerDirector : LessonPlayerViewControlDelegate {

	func startLesson(_ lesson: Model.Recipe, _ timer: ((TimeInterval) -> Void)?) {

		stopLesson()
		composer = LiveComposer()
		composer.play({ lesson })

		let timestamp = Date()
		lessonTimer = Timer.init(timeInterval: 1, repeats: true, block: { _ in
			timer?(timestamp.distance(to: Date()))
		})
		RunLoop.main.add(lessonTimer!, forMode: .default)
	}


	func stopLesson() {

		lessonTimer?.invalidate()
		lessonTimer = nil
		
		if composer.isPlaying {
			composer.stop()
		}
	}


	func isPlaying() -> Bool { composer.isPlaying }
}
