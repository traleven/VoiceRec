//
//  AudioRecorder.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import AVKit

class AudioRecorder : NSObject, ObservableObject, AVAudioRecorderDelegate {

	var audioRecorder: AVAudioRecorder!
	var meterTimer: Timer!
	var isRecording: Bool! = false
	//@Published var duration: TimeInterval = 0

	var onProgress: ((TimeInterval) -> Void)?
	var onFinish: ((Bool) -> Void)?


	func start_recording(_ url: URL, progress: ((TimeInterval)->Void)?, finish: ((Bool)->Void)?) {

		setup_recorder(url, progress: progress, finish: finish)

		audioRecorder.record()
		meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
		isRecording = true
	}


	func finishAudioRecording() -> URL {

		audioRecorder.stop()
		let url = audioRecorder.url
		audioRecorder = nil
		meterTimer.invalidate()
		print("recorded successfully.")

		isRecording = false
		NotificationCenter.default.post(name: .NoodlesFileChanged, object: url.deletingLastPathComponent())

		return url
	}


	internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

		if !flag
		{
			NSLog("Recording failed.")
		}
		onFinish?(flag)
	}


	@objc private func updateAudioMeter(timer: Timer) {

		if audioRecorder?.isRecording ?? false
		{
			//duration = audioRecorder.currentTime
			onProgress?(audioRecorder.currentTime)
			//audioRecorder.updateMeters()
		}
	}


	private func setup_recorder(_ url: URL, progress: ((TimeInterval)->Void)?, finish: ((Bool)->Void)?) {

		onProgress = progress
		onFinish = finish
		let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playAndRecord, mode: .default, policy: .default, options: [.mixWithOthers, .allowBluetooth, .allowAirPlay, .defaultToSpeaker])
			try audioSession.setActive(true)

			let recordSettings = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
								  AVSampleRateKey:44100,
								  AVNumberOfChannelsKey:2,
								  //AVEncoderBitRateKey:12800,
				//AVLinearPCMBitDepthKey:16,
				AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]

			audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
			audioRecorder.delegate = self
			audioRecorder.isMeteringEnabled = false
			audioRecorder.prepareToRecord()

		} catch let error {
			NSLog(error.localizedDescription);
			onFinish?(false)
		}
	}
}
