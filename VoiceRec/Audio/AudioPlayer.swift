//
//  AudioPlayer.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 02.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import AVKit

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

	var url: URL!

	var audioPlayer: AVAudioPlayer?
	var meterTimer: Timer!

	@Published var isPlaying: Bool!
	@Published var progress: TimeInterval = 0
	var duration: TimeInterval {
		get { audioPlayer?.duration ?? 0 }
	}
	var progress01: Double {
		get { audioPlayer != nil ? progress / audioPlayer!.duration : 0 }
	}

	var onProgress: ((TimeInterval, TimeInterval) -> Void)?
	var onComplete: ((Bool) -> Void)?

	init(_ url: URL!) {
		super.init()

		self.url = url
		isPlaying = false
	}


	func prepare_play() {

		if (audioPlayer != nil) {
			audioPlayer!.currentTime = 0
			return
		}

		do {

			audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer!.delegate = self
			audioPlayer!.isMeteringEnabled = false
			audioPlayer!.prepareToPlay()
			audioPlayer!.currentTime = 0

		} catch let error {

			NSLog(error.localizedDescription)

		}
	}


	func play(onProgress: @escaping (TimeInterval, TimeInterval) -> Void, onFinish: @escaping (Bool) -> Void) {

		self.onProgress = onProgress
		self.onComplete = onFinish

		self.play()
	}


	func play() {

		if FileManager.default.fileExists(atPath: url.path) {
			prepare_play()
			audioPlayer!.play()
			isPlaying = true
			meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
		} else {
			NSLog("Audio file is missing: %@", url.path)
			isPlaying = false
			self.onComplete?(false)
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
		onComplete?(true)
	}


	func stop(silent: Bool) {

		audioPlayer?.stop()
		isPlaying = false
		if (!silent) {
			onComplete?(true)
		}
	}


	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

		isPlaying = false
		onComplete?(true)
	}
}
