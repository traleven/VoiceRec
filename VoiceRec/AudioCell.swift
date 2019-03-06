//
//  AudioCell.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class AudioCell: UITableViewCell {

	@IBOutlet var title: UILabel!
	@IBOutlet var progress: UIProgressView!
	@IBOutlet var playButton: UIButton!
	@IBOutlet var composeSwitch: UISwitch!

	var data: AudioData?

	func setData(_ data: AudioData!) {

		self.data = data
		title.text = self.data?.url?.lastPathComponent
		playButton.setTitle((data.audioPlayer?.isPlaying ?? false) ? "(||)" : "(>)", for: .normal)
		composeSwitch.setOn(DB.music.getValue(forKey: title.text ?? "") == "y", animated: false)
	}


	@IBAction func toggle_play(_ sender: UIButton) {

		if (data?.audioPlayer?.isPlaying ?? true) {
			data?.audioPlayer?.stop()
		} else {
			let progress = { (_ current: TimeInterval, _ total: TimeInterval) -> Void in
				self.progress.progress = Float(current.magnitude / total.magnitude)
			}
			let completion = { () -> Void in
				self.progress.progress = 0
				self.playButton.setTitle("(>)", for: .normal)
			}
			data?.audioPlayer?.play(onProgress: progress, onFinish: completion)
			playButton.setTitle("(||)", for: .normal)
		}
	}


	@IBAction func toggle_composer(_ sender: UISwitch) {

		self.data?.compose = sender.isOn
		DB.music.setValue(forKey: title.text ?? "", value: sender.isOn ? "y" : "n")
		DB.music.flush()
	}
}
