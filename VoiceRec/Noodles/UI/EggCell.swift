//
//  EggCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 09.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class EggCell: UITableViewCell {

	@objc dynamic var data : Egg? {
		didSet {
			caption?.text = data?.name
		}
	}

	@IBOutlet var caption : UILabel!
}
