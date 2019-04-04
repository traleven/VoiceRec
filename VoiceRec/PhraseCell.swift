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
	@IBOutlet var presetLabel: UILabel!

	var data: DirectoryData?

	func setData(_ data: DirectoryData) {

		self.data = data
		title.text = data.url.lastPathComponent
		composeSwitch.setOn(data.compose, animated: false)
		presetLabel.text = data.preset
	}


	@IBAction func toggle_composer(_ sender: UISwitch) {

		if self.data != nil {

			if sender.isOn {
				let alertController = UIAlertController(title: "Select preset", message: "Choose language sequence preset for this phrase", preferredStyle: .actionSheet)
				alertController.popoverPresentationController?.sourceView = self.parentViewController?.view

				let optionHandler = { (_ action: UIAlertAction) in
					self.setPreset(action.title ?? "")
				}

				if DB.presets.data.count == 0 {
					DB.presets.data.append("NFNFF")
					DB.presets.data.append("NF")
					DB.presets.data.append("FNFF")
					DB.presets.data.append("FN")
					DB.presets.flush()
				}

				for preset in DB.presets.data {
					alertController.addAction(UIAlertAction(title: preset, style: .default, handler: optionHandler))
				}

				alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
					sender.setOn(false, animated: true)
				})

				self.parentViewController?.present(alertController, animated: true, completion: nil)
			} else {
				setPreset("")
			}
		}
	}


	func setPreset(_ preset: String) {

		data!.compose = preset != ""
		data!.preset = preset
		DB.phrases.setValue(forKey: data!.relativePath, value: preset)
		DB.phrases.flush()
		presetLabel.text = data!.preset
	}
}
