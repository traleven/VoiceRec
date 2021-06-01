//
//  PrhaseEditDelegate.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 20.05.21.
//

import UIKit

extension PhrasesDirector : PhraseEditViewControlDelegate {
	typealias RefreshHandle = () -> Void

	func startRecording(to phrase: URL, for language: Language, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?) {
		let audioFile = FileUtils.getNewPhraseFile(for: phrase, withExtension: "\(language).m4a")
		self.startRecording(to: audioFile, progress: progress, finish: finish)
	}

	func stopRecording(_ refreshHandle: RefreshHandle?) {
		let _ = self.stopRecording()
		refreshHandle?()
	}

	func startPlaying(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {
		self.playAudio(url, progress: progress, finish: finish)
	}

	func stopPlaying(_ url: URL, _ refreshHandle: RefreshHandle?) {
		let _ = self.stopPlaying(url)
		refreshHandle?()
	}

	func stopAllAudio() {
		let _ = self.stopRecording()
		self.stopPlayingAll()
	}
}
