//
//  EggCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 09.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class EggCell: DynamicCell<Egg> {

	@IBOutlet var caption : UILabel!


	override func onNewData(_ newData: Egg?) {
		
		caption?.text = newData?.name
	}
}
