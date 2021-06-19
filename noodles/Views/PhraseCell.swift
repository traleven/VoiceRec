//
//  PhraseCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 27.05.21.
//

import UIKit

class PhraseCell : UITableViewCell {

	@IBOutlet var label : UILabel!
	@IBOutlet var indexLabel : UILabel?

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	override func prepareForReuse() {
		super.prepareForReuse()
	}


	func prepare(for phrase: Model.Phrase, at index: Int) {
		label.attributedText = phrase.attributedName
		indexLabel?.text = "\(index)"
	}
}
