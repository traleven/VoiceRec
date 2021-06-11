//
//  LanguageCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 09.06.21.
//

import UIKit

class LanguageCell : UITableViewCell {

	@IBOutlet var icon : UILabel!
	@IBOutlet var label : UILabel!
	@IBOutlet var level : UILabel!
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


	func prepare(for language: Language, of user: Model.User, at index: Int) {
		icon.text = language.flag.rawValue
		label.text = language.name
		level.text = user[language]
		indexLabel?.text = "\(index)"
	}
}
