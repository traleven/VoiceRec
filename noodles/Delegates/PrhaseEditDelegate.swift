//
//  PrhaseEditDelegate.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 20.05.21.
//

import UIKit

extension PhrasesDirector : PhraseEditViewControlDelegate {
	typealias RefreshHandle = () -> Void

	func startRecording(to phrase: URL, for language: String, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?) {
		let audioFile = FileUtils.getNewPhraseFile(for: phrase, withExtension: "\(language).m4a")
		recorder.start_recording(audioFile, progress: progress, finish: { (result: Bool) -> Void in
			finish?(result ? audioFile : nil)
		})
	}

	func stopRecording(_ refreshHandle: RefreshHandle?) {
		let _ = recorder.finishAudioRecording()
		refreshHandle?()
	}

	func startPlaying(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {
		if let player = players[url] {
			player.play()
			return
		}
		let player = AudioPlayer(url)
		player.play(onProgress: progress!) { [weak self] (result: Bool) in
			finish?(result)
			self?.players.removeValue(forKey: url)
		}
		players[url] = player
	}

	func stopPlaying(_ url: URL, _ refreshHandle: RefreshHandle) {
		if let player = players[url] {
			player.stop()
		}
		refreshHandle()
	}
}
