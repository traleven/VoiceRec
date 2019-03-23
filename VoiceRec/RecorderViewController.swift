//
//  FirstViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import AVKit

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet var record_btn_ref: UIButton!
	@IBOutlet var progress_ref: UIProgressView!
	@IBOutlet var language_ref: UILabel!

	var recorder: AudioRecorder!
	var player: AudioPlayer?
	var isAudioRecordingGranted: Bool!
	var languageName: String?
	var phrase: String?
	var filePath: URL!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		check_record_permission()
		recorder = AudioRecorder()

		if (FileManager.default.fileExists(atPath: filePath.path)) {
			player = AudioPlayer(filePath)
			record_btn_ref.setTitle("Play", for: .normal)
		}
	}


	override func viewWillAppear(_ animated: Bool) {

		language_ref?.text = languageName
	}


	func setData(directoryUrl: URL!, language: String!, phrase: String!) {

		self.phrase = phrase
		self.languageName = language
		self.filePath = directoryUrl.appendingPathComponent(String.init(format: "%@.m4a", language), isDirectory: false)

		language_ref?.text = language
	}


	func getFileUrl() -> URL {

		let filename = String.init(format: "%@.%@", languageName ?? "default", "m4a")
		let filePath = FileUtils.getDirectory("recordings", phrase ?? "default").appendingPathComponent(filename)
		return filePath
	}


	@IBAction func togglePlayMode(_ sender: Any) {

		if (player != nil) {
			if (player!.isPlaying) {
				player!.stop()
			} else {
				player!.play(onProgress: { (_ progress: TimeInterval, _ total: TimeInterval) in
					self.progress_ref.progress = Float(progress.magnitude / total.magnitude)
				}, onFinish: {_ in 
					self.progress_ref.progress = 0
					self.record_btn_ref.setTitle("Play", for: .normal)
				})
			}
		} else {
			if (recorder.isRecording) {
				recorder.finishAudioRecording()
			} else {
				recorder.start_recording(filePath, progress: { (_ progress: TimeInterval) in
					let hr = Int((progress / 60) / 60)
					let min = Int(progress / 60)
					let sec = Int(progress.truncatingRemainder(dividingBy: 60))
					let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
					self.record_btn_ref.setTitle(totalTimeString, for: .normal)
				}) { (_ success: Bool) in
					if (success) {
						self.player = AudioPlayer(self.filePath)
						self.record_btn_ref.setTitle("Play", for: .normal)
					} else {
						self.record_btn_ref.setTitle("Record", for: .normal)
					}
				}
			}
		}
	}


	@IBAction func deleteFile() {

		if (FileManager.default.fileExists(atPath: filePath.path)) {
			let ac = UIAlertController(title: "Delete audio?", message: "Are you sure?", preferredStyle: .actionSheet)

			ac.addAction(UIAlertAction(title: "Delete", style: .destructive)
			{
				(result : UIAlertAction) -> Void in
				_ = self.navigationController?.popViewController(animated: true)
				do {
					try FileManager.default.removeItem(at: self.filePath)
				} catch let error {
					NSLog(error.localizedDescription)
				}
			})

			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel)
			{
				(result : UIAlertAction) -> Void in
				_ = self.navigationController?.popViewController(animated: true)
			})

			self.present(ac, animated: true)
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
