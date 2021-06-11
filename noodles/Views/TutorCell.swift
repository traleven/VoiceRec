//
//  TutorCell.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 11.06.21.
//

import UIKit

class TutorCell : UITableViewCell {
	static let defaultIcon: UIImage? = UIImage(systemName: "person.crop.circle")

	@IBOutlet var icon : UIImageView?
	@IBOutlet var label : UILabel?
	@IBOutlet var language : UILabel?
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


	func prepare(for tutor: Model.User?, of user: Model.User, at index: Int) {
		icon?.image = tutor?.icon ?? Self.defaultIcon
		label?.text = tutor?.name
		language?.text = tutor?.base.flag.rawValue
		indexLabel?.text = "\(index)"
	}
}
