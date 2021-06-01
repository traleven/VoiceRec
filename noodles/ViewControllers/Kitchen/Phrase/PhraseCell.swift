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


	func prepare(for egg: Model.Phrase, at index: Int, preferBaseLanguage: Bool) {
		if preferBaseLanguage {
			label.text = egg.baseText.isEmpty ? egg.targetText : egg.baseText
		} else {
			label.text = egg.targetText.isEmpty ? egg.baseText : egg.targetText
		}
		indexLabel?.text = "\(index)"
	}
}
