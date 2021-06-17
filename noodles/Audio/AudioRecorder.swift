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
		if audioSession.category != .record
			|| audioSession.mode != .default
			|| audioSession.routeSharingPolicy != .default
			|| !audioSession.categoryOptions.isSuperset(of: [.allowBluetooth]) {
			do {
				try audioSession.setCategory(.record, mode: .default, policy: .default, options: [.allowBluetooth])
				try audioSession.setActive(true)
			} catch let error {
				NSLog("Failed to initialize proper audio session category: \(error.localizedDescription)");
				onFinish?(false)
			}
		}

		let recordSettings = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
							  AVSampleRateKey:44100,
							  AVNumberOfChannelsKey:2,
							  //AVEncoderBitRateKey:12800,
			//AVLinearPCMBitDepthKey:16,
			AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]

		do {
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
