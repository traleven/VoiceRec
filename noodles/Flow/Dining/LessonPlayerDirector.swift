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
	unowned let nowPlayableBehavior: NowPlayable = ConfigModel.shared.nowPlayableBehavior

	init(router: Router, timer: ((TimeInterval) -> Void)?) {
		self.defaultTimerHandler = timer
		super.init(router: router)

		setupRemoteCommands()
	}
}

extension LessonPlayerDirector : LessonPlayerViewFlowDelegate {
}

extension LessonPlayerDirector : LessonPlayerViewControlDelegate {

	func startLesson(_ lesson: Model.Recipe, _ timer: ((TimeInterval) -> Void)? = nil) {

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

	func setupRemoteCommands() {
		
		// Construct lists of commands to be registered or disabled.
		var registeredCommands = [.play, .stop] as [NowPlayableCommand]
		var enabledCommands = [.play, .stop] as [NowPlayableCommand]

		for group in ConfigModel.shared.commandCollections {
			registeredCommands.append(contentsOf: group.commands.compactMap { $0.shouldRegister ? $0.command : nil })
			enabledCommands.append(contentsOf: group.commands.compactMap { $0.shouldDisable ? $0.command : nil })
		}

		// Configure the app for Now Playing Info and Remote Command Center behaviors.
		try! nowPlayableBehavior.handleNowPlayableConfiguration(commands: registeredCommands,
															   disabledCommands: enabledCommands,
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

		default:
			break
		}

		return .success
	}
}
