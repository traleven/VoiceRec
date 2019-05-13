//
//  DoughballCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class DoughballCell: DynamicCell<Doughball> {

	@IBOutlet var caption : UILabel!

	override func onNewData(_ newData: Doughball?) {

		caption?.text = newData?.texts[Language.native.id]
	}
}
