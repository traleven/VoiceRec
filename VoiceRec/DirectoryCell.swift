//
//  DirectoryCell.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 16.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class DirectoryCell: UITableViewCell {

	@IBOutlet var title: UILabel!

	var data: DirectoryData?

	func setData(_ data: DirectoryData) {

		self.data = data
		title.text = self.data?.url?.lastPathComponent
	}


	@IBAction func toggle_composer(_ sender: UISwitch) {

		self.data?.compose = sender.isOn
		DB.phrases.setValue(forKey: title.text ?? "", value: sender.isOn ? "y" : "n")
		DB.phrases.flush()
	}
}
