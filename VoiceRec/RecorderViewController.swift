//
//  FirstViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import AVKit

class RecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

	@IBOutlet var recordingTimeLabel: UILabel!
	@IBOutlet var record_btn_ref: NSObject!

	var audioRecorder: AVAudioRecorder!
	var audioPlayer : AVAudioPlayer!
	var meterTimer: Timer!

	var isAudioRecordingGranted: Bool!
	var isRecording: Bool! = false
	var isPlaying: Bool! = false


	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		check_record_permission()
	}


	func check_record_permission() {

		let audioSession = AVAudioSession.sharedInstance()
		switch audioSession.recordPermission {
		case .granted:
			isAudioRecordingGranted = true
			break
		case .denied:
			isAudioRecordingGranted = false
			break
		case .undetermined:
			AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
					if allowed {
						self.isAudioRecordingGranted = true
					} else {
						self.isAudioRecordingGranted = false
					}
			})
			break
		default:
			break
		}
	}


	func setup_recorder(){

		let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
			try audioSession.setActive(true)

			let recordSettings = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
								  AVSampleRateKey:44100,
								  AVNumberOfChannelsKey:2,
								  //AVEncoderBitRateKey:12800,
								  //AVLinearPCMBitDepthKey:16,
								  AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]

			audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: recordSettings)
			audioRecorder.delegate = self
			audioRecorder.isMeteringEnabled = true
			audioRecorder.prepareToRecord()

		} catch let error {
			NSLog(error.localizedDescription);
		}
	}


	func getFileUrl() -> URL {

		let date = NSDate()
		let filename = String.init(format: "%@.%@", date, "m4a")
		let filePath = FileUtils.getDocumentsDirectory().appendingPathComponent(filename)
		return filePath
	}


	@objc func updateAudioMeter(timer: Timer) {

		if audioRecorder.isRecording
		{
			let hr = Int((audioRecorder.currentTime / 60) / 60)
			let min = Int(audioRecorder.currentTime / 60)
			let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			recordingTimeLabel.text = totalTimeString
			audioRecorder.updateMeters()
		}
	}


	@IBAction func toggleRecording(_ sender: NSObject) {

		if isRecording {
			finishAudioRecording(sender)
		} else {
			start_recording(sender)
		}
	}


	@IBAction func start_recording(_ sender: NSObject) {

		setup_recorder()

		audioRecorder.record()
		meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
		recordingTimeLabel.text = "Recording..."
		isRecording = true
	}


	@IBAction func finishAudioRecording(_ sender: NSObject) {

		audioRecorder.stop()
		audioRecorder = nil
		meterTimer.invalidate()
		print("recorded successfully.")

		recordingTimeLabel.text = "Recorded"
		isRecording = false
	}


	func prepare_play() {

		do
		{
			audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
			audioPlayer.delegate = self
			audioPlayer.prepareToPlay()
		}
		catch{
			print("Error")
		}
	}


	@IBAction func play_recording(_ sender: Any) {

		if(isPlaying)
		{
			audioPlayer.stop()
			isPlaying = false
		}
		else
		{
			if FileManager.default.fileExists(atPath: getFileUrl().path)
			{
				prepare_play()
				audioPlayer.play()
				isPlaying = true
			}
			else
			{
				display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
			}
		}
	}


	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

		if !flag
		{
			display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
		}
	}


	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

	}

	
	func display_alert(msg_title : String , msg_desc : String ,action_title : String) {
		
		let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: action_title, style: .default)
		{
			(result : UIAlertAction) -> Void in
		_ = self.navigationController?.popViewController(animated: true)
		})
		present(ac, animated: true)
	}
}

