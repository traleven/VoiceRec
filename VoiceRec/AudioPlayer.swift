//
//  AudioPlayer.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 02.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import AVKit

class AudioPlayer: NSObject, AVAudioPlayerDelegate {

	var url: URL!

	var audioPlayer: AVAudioPlayer?
	var meterTimer: Timer!

	var isPlaying: Bool!
	var onProgress: ((TimeInterval, TimeInterval) -> Void)?
	var onComplete: (() -> Void)?

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

		} catch let error {

			NSLog(error.localizedDescription)

		}
	}


	func play(onProgress: @escaping (TimeInterval, TimeInterval) -> Void, onFinish: @escaping () -> Void) {

		self.onProgress = onProgress
		self.onComplete = onFinish

		if FileManager.default.fileExists(atPath: url.path) {
			prepare_play()
			audioPlayer!.play()
			isPlaying = true
			meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
		} else {
			NSLog("Audio file is missing: %@", url.path)
			isPlaying = false
			self.onComplete?()
		}
	}


	@objc func updateAudioMeter(timer: Timer) {

		if audioPlayer!.isPlaying {
			onProgress!(audioPlayer!.currentTime, audioPlayer!.duration)
		}
	}


	func stop() {

		audioPlayer?.stop()
		isPlaying = false
		onComplete?()
	}


	func stop(silent: Bool) {

		audioPlayer?.stop()
		isPlaying = false
		if (!silent) {
			onComplete?()
		}
	}


	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

		isPlaying = false
		onComplete?()
	}
}
