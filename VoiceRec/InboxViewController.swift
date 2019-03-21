//
//  InboxViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 21.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import MediaPlayer

class InboxViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet var record_btn_ref: UIButton!

	var recorder: AudioRecorder!
	var isAudioRecordingGranted: Bool!
	var filePath: URL!
	var record_btn_title: String?
	var token: NSObjectProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()

		check_record_permission()
		recorder = AudioRecorder()
		record_btn_title = record_btn_ref.title(for: .normal)
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		token = NotificationCenter.default.addObserver(forName: .appGoesBackground, object: nil, queue: .main) { (_ notification : Notification) in
			self.stopRecording()
		}
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(token!, name: .appGoesBackground, object: nil)
		stopRecording()
	}


	func getRootDirectory() -> URL {

		return FileUtils.getDirectory("INBOX")
	}


	@IBAction func togglePlayMode(_ sender: Any) {

		if recorder.isRecording {
			stopRecording()
		} else {
			startRecording()
		}
	}


	@IBAction func startRecording() {

		self.filePath = getRootDirectory().appendingPathComponent("\(Date().description).m4a", isDirectory: false)

		if !recorder.isRecording {
			recorder.start_recording(filePath, progress: {
				(_ progress: TimeInterval) in
				let hr = Int((progress / 60) / 60)
				let min = Int(progress / 60)
				let sec = Int(progress.truncatingRemainder(dividingBy: 60))
				let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
				self.record_btn_ref.setTitle(totalTimeString, for: .normal)
			}) {
				(_ success: Bool) in
				self.record_btn_ref.setTitle(self.record_btn_title, for: .normal)
				NotificationCenter.default.post(name: .refreshMusic, object: self)
			}
		}
	}


	@IBAction func stopRecording() {
		if recorder.isRecording {
			recorder.finishAudioRecording()
		}
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
}
