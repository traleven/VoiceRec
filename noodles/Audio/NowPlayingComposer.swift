//
//  NowPlayingComposer.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 17.06.21.
//  Based on `AssetPlayer` from Apple `NowPlayable` demo
//

import Foundation
import MediaPlayer

class NowPlayingLiveComposer : LiveComposer {

	// Possible values of the `playerState` property.
	enum PlayerState {
		case stopped
		case playing
	}

	// The app-supplied object that provides `NowPlayable`-conformant behavior.
	private unowned let nowPlayableBehavior: NowPlayable  = ConfigModel.shared.nowPlayableBehavior

	// Metadata for each item.
	private var staticMetadata: NowPlayableStaticMetadata?
	//private var musicPlayer: AudioPlayer?
	private var lessonProvider: LiveComposer.LessonProvider?

	// The internal state of this AssetPlayer separate from the state
	// of its AVQueuePlayer.
	private var playerState: PlayerState = .stopped {
		didSet {
			//NSLog("%@", "**** Set player state \(playerState)")
		}
	}

	// `true` if the current session has been interrupted by another app.
	private var isInterrupted: Bool = false

	// Private observers of notifications and property changes.
	private var statusObserver: NSObjectProtocol!

	// A shorter name for a very long property name.
	private static let mediaSelectionKey = "availableMediaCharacteristicsWithMediaSelectionOptions"


	override func play(_ lesson: @escaping LiveComposer.LessonProvider) {

		self.lessonProvider = lesson
		let lesson = lesson()
		self.staticMetadata = NowPlayableStaticMetadata(
			assetURL: lesson.music ?? lesson.id,
			mediaType: .audio,
			isLiveStream: true,
			title: lesson.name,
			artist: nil,
			artwork: MPMediaItemArtwork(boundsSize: CGSize(width: 200, height: 200), requestHandler: {_ in
				Model.User.Me.icon ?? UIImage(named: "person.circle")!
			}),
			albumArtist: nil,
			albumTitle: nil
		)

		// Start a playback session.
		try! nowPlayableBehavior.handleNowPlayableSessionStart()

		// Start the player.
		if let lessonProvider = lessonProvider {
			playerState = .playing
			super.play(lessonProvider)
			handlePlayerItemChange()
		}
	}

	// Stop the playback session.
	override func stop() {

		statusObserver = nil

		super.stop()
		playerState = .stopped

		nowPlayableBehavior.handleNowPlayableSessionEnd()
	}

	// MARK: Now Playing Info

	// Helper method: update Now Playing Info when the current item changes.
	private func handlePlayerItemChange() {

		guard playerState != .stopped else { return }

		// Set the Now Playing Info from static item metadata.
		if let metadata = staticMetadata {
			nowPlayableBehavior.handleNowPlayableItemChange(metadata: metadata)
		}
	}

	// Helper method: update Now Playing Info when playback rate or position changes.

	// MARK: Playback Control

	// The following methods handle various playback conditions triggered by remote commands.
	func play() {

		switch playerState {

		case .stopped:
			playerState = .playing
			if let lessonProvider = lessonProvider {
				play(lessonProvider)
			}

		case .playing:
			break
		}
	}

	// Helper method to get the media selection group and media selection for enabling a language option.
	private func enabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> (AVMediaSelectionOption, AVMediaSelectionGroup)? {

		// In your code, you would implement your logic for choosing a media selection option
		// from a suitable media selection group.

		// Note that, when the current track is being played remotely via AirPlay, the language option
		// may not exactly match an option in your local asset's media selection. You may need to consider
		// an approximate comparison algorithm to determine the nearest match.

		// If you cannot find an exact or approximate match, you should return `nil` to ignore the
		// enable command.

		return nil
	}

	// Helper method to get the media selection group for disabling a language option`.
	private func disabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> AVMediaSelectionGroup? {

		// In your code, you would implement your logic for finding the media selection group
		// being disabled.

		// Note that, when the current track is being played remotely via AirPlay, the language option
		// may not exactly determine a media selection group in your local asset. You may need to consider
		// an approximate comparison algorithm to determine the nearest match.

		// If you cannot find an exact or approximate match, you should return `nil` to ignore the
		// disable command.

		return nil
	}
}
