//
//  RecipeCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class RecipeCell: DynamicCell<Recipe> {

	@IBOutlet var caption : UILabel!

	override func onNewData(_ newData: Recipe?) {

		caption?.text = newData?.name
	}
}
