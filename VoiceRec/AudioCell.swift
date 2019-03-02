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

	var url: URL?

	func setData(_ dataUrl: URL) {

		url = dataUrl
		title.text = url?.lastPathComponent
	}
}
