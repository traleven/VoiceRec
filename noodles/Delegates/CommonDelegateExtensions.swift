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
	fileprivate typealias DetailedResultCallback = (AudioPlayer?, PlayerResult) -> Void

	func playAudio(_ url: URL, volume: Float, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		if let player = players[url] {
			player.setVolume(volume, fadeDuration: 0.1)
			player.play()
		}
		let player = AudioPlayer(url, volume: volume)
		player.play(onProgress: { progress?($0, $1) }) { [weak self] (result: PlayerResult) in
			finish?(result)
			self?.players.removeValue(forKey: url)
		}
		players[url] = player
	}

	func playAudio(_ url: URL, at alias: URL, volume: Float, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {

		playAudio(url, at: alias, volume: volume, progress: progress, finish: {
			finish?($1)
		})
	}

	fileprivate func playAudio(_ url: URL, at alias: URL, volume: Float, progress: PlayerProgressCallback?, finish: DetailedResultCallback?) {

		if let player = players[alias] {
			player.stop()
		}
		let player = AudioPlayer(url, volume: volume)
		player.play(onProgress: { progress?($0, $1) }) { [weak self] (result: PlayerResult) in
			finish?(player, result)
			self?.players.removeValue(forKey: alias)
		}
		players[alias] = player

	}

	func playAudio(_ noodle: Model.Noodle, with delay: Float, volume: Float, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		playAudio(noodle.makeIterator(), at: noodle.phrase.id, with: Double(delay), volume: volume, progress: progress, finish: {
			finish?($1)
		})
	}

	func playAudio(_ noodle: Model.Noodle, at alias: URL, with delay: Float, volume: Float, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		playAudio(noodle.makeIterator(), at: alias, with: Double(delay), volume: volume, progress: progress, finish: {
			finish?($1)
		})
	}

	fileprivate func playAudio<Iterator: IteratorProtocol>(_ iterator: Iterator,
														   at alias: URL,
														   with delay: Double,
														   volume: Float,
														   progress: PlayerProgressCallback?,
														   finish: DetailedResultCallback?
	) where Iterator.Element == URL {

		var iterator = iterator
		if let url = iterator.next() {
			playAudio(url, at: alias, volume: volume, progress: progress, finish: { (player: AudioPlayer?, result: PlayerResult) -> Void in
				guard result != .stopped else {
					finish?(player, result)
					return
				}
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
					self.playAudio(iterator, at: alias, with: delay, volume: player?.volume ?? volume, progress: progress, finish: finish)
				}
			})
		} else {
			finish?(nil, .finished)
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
