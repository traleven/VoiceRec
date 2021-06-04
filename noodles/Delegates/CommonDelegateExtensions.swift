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

	func playAudio(_ url: URL, at alias: URL, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {

		if let player = players[alias] {
			player.stop()
		}
		let player = AudioPlayer(url)
		player.play(onProgress: { progress?($0, $1) }) { [weak self] (result: Bool) in
			finish?(result)
			self?.players.removeValue(forKey: alias)
		}
		players[alias] = player

	}

	func playAudio(_ noodle: Model.Noodle, with delay: Float, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {
		playAudio(noodle.makeIterator(), at: noodle.phrase.id, with: Double(delay), progress: progress, finish: finish)
	}

	func playAudio(_ noodle: Model.Noodle, at alias: URL, with delay: Float, progress: PlayerProgressCallback?, finish: ((Bool) -> Void)?) {
		playAudio(noodle.makeIterator(), at: alias, with: Double(delay), progress: progress, finish: finish)
	}

	fileprivate func playAudio<Iterator: IteratorProtocol>(_ iterator: Iterator,
														   at alias: URL,
														   with delay: Double,
														   progress: PlayerProgressCallback?,
														   finish: ((Bool) -> Void)?
	) where Iterator.Element == URL {

		var iterator = iterator
		if let url = iterator.next() {
			playAudio(url, at: alias, progress: progress, finish: { (result: Bool) -> Void in
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
					self.playAudio(iterator, at: alias, with: delay, progress: progress, finish: finish)
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
