//
//  DirectoryCell.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 03.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhraseCell: UITableViewCell {

	@IBOutlet var title: UILabel!
	@IBOutlet var composeSwitch: UISwitch!

	var data: DirectoryData?

	func setData(_ data: DirectoryData) {

		self.data = data
		title.text = self.data?.url?.lastPathComponent
		composeSwitch.setOn(DB.phrases.getValue(forKey: self.data?.relativePath ?? "") == "y", animated: false)
	}


	@IBAction func toggle_composer(_ sender: UISwitch) {

		self.data?.compose = sender.isOn
		DB.phrases.setValue(forKey: self.data?.relativePath ?? "", value: sender.isOn ? "y" : "n")
		DB.phrases.flush()
	}
}
