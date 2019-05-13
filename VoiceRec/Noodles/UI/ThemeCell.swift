//
//  ThemeCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class ThemeCell: DynamicCell<Theme> {

	@IBOutlet var caption : UILabel!

	override func onNewData(_ newData: Theme?) {

		caption?.text = newData?.name
	}
}
