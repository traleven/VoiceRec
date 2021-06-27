//
//  LessonPlayerDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit
import MediaPlayer

class LessonPlayerDirector : DefaultDirector {
	var players: [URL: AudioPlayer] = [:]
	var composer = NowPlayingLiveComposer()
	var lessonTimer: Timer?
	var defaultTimerHandler: ((TimeInterval) -> Void)?
	var defaultPrevHandler: (() -> Void)?
	var defaultNextHandler: (() -> Void)?
	unowned let nowPlayableBehavior: NowPlayable = ConfigModel.shared.nowPlayableBehavior

	init(router: Router, prev: (() -> Void)?, next: (() -> Void)?, timer: ((TimeInterval) -> Void)?) {
		self.defaultTimerHandler = timer
		self.defaultNextHandler = next
		self.defaultPrevHandler = prev
		super.init(router: router)

		setupRemoteCommands()
	}
}

extension LessonPlayerDirector : LessonPlayerViewFlowDelegate {
}

extension LessonPlayerDirector : LessonPlayerViewControlDelegate {

	func startLesson(_ lesson: Model.Recipe, _ timer: ((TimeInterval) -> Void)?) {

		stopLesson()
		composer = NowPlayingLiveComposer()

		composer.play({ lesson })

		let timestamp = Date()
		let timer = timer ?? self.defaultTimerHandler
		lessonTimer = Timer.init(timeInterval: 1, repeats: true, block: { _ in
			timer?(timestamp.distance(to: Date()))
		})
		RunLoop.main.add(lessonTimer!, forMode: .default)
	}


	private func startLesson() {

		stopLesson()
		
		composer.play()
		let timestamp = Date()
		let timer = self.defaultTimerHandler
		lessonTimer = Timer.init(timeInterval: 1, repeats: true, block: { _ in
			timer?(timestamp.distance(to: Date()))
		})
		RunLoop.main.add(lessonTimer!, forMode: .default)
	}


	func stopLesson() {

		if composer.isPlaying {
			composer.stop()
		}

		lessonTimer?.fire()
		lessonTimer?.invalidate()
		lessonTimer = nil
	}


	func isPlaying() -> Bool { composer.isPlaying }


	func delete(_ lesson: Model.Recipe, _ refresh: (() -> Void)?) {

		if isPlaying() {
			stopLesson()
		}
		FileUtils.delete(lesson.id)
		refresh?()
	}


	func share(_ lesson: Model.Recipe) {
		DispatchQueue.global().async {
			ZipUtils.zip(lesson.id, file: "\(lesson.name).noodlez") { (result: URL?) in
				if let archiveUrl = result {
					DispatchQueue.main.sync {
						// bring up the share sheet so we can send the archive with AirDrop for example
						let avc = UIActivityViewController(activityItems: [archiveUrl], applicationActivities: nil)
						self.router.present(avc) {
						}
					}
				} else {
					print("Failed")
				}
			}
		}
	}


	func export(_ lesson: Model.Recipe) {

		let activityIndicator = makeLoadingViewController()
		router.present(activityIndicator, onDismiss: nil)

		let composer = ExportComposer()
		composer.export(lesson: lesson, completionHandler: { [weak self] (url: URL, error: Error?) in
			DispatchQueue.main.async {
				self?.router.dismiss(animated: true) {
					guard error == nil else {
						print(error!)
						return
					}

					let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
					self?.router.present(avc) {
					}
				}
			}
		})
	}


	private func setupRemoteCommands() {
		
		// Construct lists of commands to be registered or disabled.
		let registeredCommands = [.play, .stop, .pause, .togglePausePlay, .previousTrack, .nextTrack] as [NowPlayableCommand]
		let disabledCommands = [] as [NowPlayableCommand]

		// Configure the app for Now Playing Info and Remote Command Center behaviors.
		try! nowPlayableBehavior.handleNowPlayableConfiguration(commands: registeredCommands,
															   disabledCommands: disabledCommands,
															   commandHandler: handleCommand(command:event:),
															   interruptionHandler: handleInterrupt(with:))
	}

	// MARK: Interruptions

	// Handle a session interruption.

	private func handleInterrupt(with interruption: NowPlayableInterruption) {

		switch interruption {

		case .began:
			composer.stop()
			//isInterrupted = true

		case .ended(let shouldPlay):
			//isInterrupted = false

			if shouldPlay {
				composer.play()
			} else {
				stopLesson()
			}

//			switch playerState {
//
//			case .stopped:
//				break
//
//			case .playing where shouldPlay:
//				play()
//
//			case .playing:
//				playerState = .paused
//
//			case .paused:
//				break
//			}

		case .failed(let error):
			print(error.localizedDescription)
			stopLesson()
		}
	}

	// MARK: Remote Commands

	// Handle a command registered with the Remote Command Center.
	private func handleCommand(command: NowPlayableCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {

		switch command {

		case .pause:
			stopLesson()

		case .play:
			startLesson()

		case .stop:
			stopLesson()

		case .togglePausePlay:
			if composer.isPlaying {
				stopLesson()
			} else {
				startLesson()
			}

		case .nextTrack:
			defaultNextHandler?()

		case .previousTrack:
			defaultPrevHandler?()

		default:
			break
		}

		return .success
	}
}
