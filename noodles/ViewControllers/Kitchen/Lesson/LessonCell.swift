//
//  LessonCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 27.05.21.
//

import UIKit

class LessonCell : UITableViewCell {

	@IBOutlet var label : UILabel!
	@IBOutlet var phraseCount : UILabel?

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	override func prepareForReuse() {
		super.prepareForReuse()
	}


	func prepare(for lesson: Model.Recipe) {

		label.text = lesson.name
		phraseCount?.text = "\(lesson.phraseCount) phrases"
	}
}
