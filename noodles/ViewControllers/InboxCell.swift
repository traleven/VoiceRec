//
//  InboxCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 06.05.21.
//

import UIKit

class InboxCell : UITableViewCell {

	@IBOutlet var label : UILabel!

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	override func prepareForReuse() {
		super.prepareForReuse()
	}


	func prepare(for egg: Model.Egg) {
	}
}

class InboxAudioCell : InboxCell {
	override func prepare(for egg: Model.Egg) {
		label.text = egg.name
	}
}

class InboxTextCell: InboxCell {
	override func prepare(for egg: Model.Egg) {
		label.text = egg.name
	}
}

class InboxFolderCell: InboxCell {
	override func prepare(for egg: Model.Egg) {
		label.text = egg.name
	}
}
