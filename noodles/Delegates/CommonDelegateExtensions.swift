//
//  CommonDelegateExtensions.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 01.06.21.
//

import UIKit

protocol AudioPlayerImplementation: class {
	var players: [URL: AudioPlayer] { get set }
}

extension AudioPlayerImplementation {
	typealias PlayerProgressCallback = ((TimeInterval, TimeInterval) -> Void)

	func playAudio(_ url: URL, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {
		if let player = players[url] {
			player.play()
			return
		}
		let player = AudioPlayer(url)
		player.play(onProgress: { progress?($0, $1) }) { [weak self] (result: Bool) in
			finish?(result)
			self?.players.removeValue(forKey: url)
		}
		players[url] = player
	}

	func playAudio(_ noodle: Model.Noodle, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {
		playAudio(noodle.makeIterator(), progress: progress, finish: finish)
	}

	fileprivate func playAudio<Iterator: IteratorProtocol>(_ iterator: Iterator, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) where Iterator.Element == URL {
		var iterator = iterator
		if let url = iterator.next() {
			playAudio(url, progress: progress, finish: { (result: Bool) -> Void in
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Settings.phrase.delay.inner) {
					self.playAudio(iterator, progress: progress, finish: finish)
				}
			})
		} else {
			finish?(true)
		}
	}

	func stopPlaying(_ url: URL) -> Bool {
		if let player = players[url] {
			player.stop()
			return true
		}
		return false
	}

	func stopPlayingAll() {
		for player in players {
			player.value.stop()
		}
	}
}

protocol AudioRecorderImplementation: class {
	var recorder: AudioRecorder { get }
}

extension AudioRecorderImplementation {
	func startRecording(to file: URL, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?) {

		if recorder.isRecording {
			_ = recorder.finishAudioRecording()
		}

		recorder.start_recording(file, progress: progress, finish: { (result: Bool) -> Void in
			finish?(result ? file : nil)
		})
	}

	func stopRecording() -> URL? {
		if recorder.isRecording {
			return recorder.finishAudioRecording()
		}
		return nil
	}
}
