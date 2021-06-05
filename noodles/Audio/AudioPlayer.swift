//
//  AudioPlayer.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 02.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import AVKit

typealias PlayerProgressCallback = (TimeInterval, TimeInterval) -> Void
typealias PlayerResultCallback = (PlayerResult) -> Void

enum PlayerResult {
	case finished
	case stopped
	case failed
}

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

	var url: URL?

	var audioPlayer: AVAudioPlayer?
	var meterTimer: Timer!
	var volume: Float

	@Published var isPlaying: Bool!
	@Published var progress: TimeInterval = 0
	var duration: TimeInterval {
		get { audioPlayer?.duration ?? 0 }
	}
	var progress01: Double {
		get { audioPlayer != nil ? progress / audioPlayer!.duration : 0 }
	}
	var ready: Bool {
		url != nil
	}

	var onProgress: PlayerProgressCallback?
	var onComplete: PlayerResultCallback?

	init(_ url: URL?, volume: Float) {
		self.url = url
		self.volume = volume
		isPlaying = false

		super.init()
	}


	private func prepare_play() -> Bool {

		if (audioPlayer != nil) {
			audioPlayer!.currentTime = 0
			return false
		}

		guard url != nil else {
			return false
		}

		let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
		if audioSession.category != .playAndRecord
			|| audioSession.mode != .default
			|| audioSession.routeSharingPolicy != .default
			|| !audioSession.categoryOptions.isSuperset(of: [.mixWithOthers, .allowBluetooth, .allowAirPlay, .defaultToSpeaker]) {

			do {
				try audioSession.setCategory(
					.playAndRecord,
					mode: .default,
					policy: .default,
					options: [.mixWithOthers, .allowBluetooth, .allowAirPlay, .defaultToSpeaker]
				)
				try audioSession.setActive(true)
			} catch let error {
				NSLog("Failed to activate audio session: \(error.localizedDescription)")
				return false
			}
		}

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url!)
			audioPlayer!.delegate = self
			audioPlayer!.isMeteringEnabled = false
			audioPlayer!.prepareToPlay()
			audioPlayer!.currentTime = 0
			audioPlayer!.setVolume(volume, fadeDuration: 0)

		} catch let error {

			NSLog("Failed to play audio file \(url?.relativePath ?? url?.debugDescription ?? "'nil'"): \(error.localizedDescription)")
			return false

		}
		return true
	}


	func play(onProgress: @escaping PlayerProgressCallback, onFinish: @escaping PlayerResultCallback) {

		self.onProgress = onProgress
		self.onComplete = onFinish

		self.play()
	}


	func play() {

		guard url != nil else {
			NSLog("Can not play null audio")
			return
		}

		if FileManager.default.fileExists(atPath: url!.path) {
			guard prepare_play() else {
				return
			}
			audioPlayer!.play()
			isPlaying = true
			meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
		} else {
			NSLog("Audio file is missing: %@", url!.path)
			isPlaying = false
			self.onComplete?(.failed)
		}
	}


	@objc func updateAudioMeter(timer: Timer) {

		if audioPlayer!.isPlaying {
			progress = audioPlayer!.currentTime
			onProgress?(audioPlayer!.currentTime, audioPlayer!.duration)
		}
	}


	func stop() {

		audioPlayer?.stop()
		isPlaying = false
		onComplete?(.stopped)
	}


	func stop(silent: Bool) {

		audioPlayer?.stop()
		isPlaying = false
		if (!silent) {
			onComplete?(.stopped)
		}
	}


	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

		isPlaying = false
		onComplete?(flag ? .finished : .failed)
	}


	func setVolume(_ volume: Float, fadeDuration: TimeInterval = 0) {

		self.volume = volume
		audioPlayer?.setVolume(volume, fadeDuration: fadeDuration)
	}
}
