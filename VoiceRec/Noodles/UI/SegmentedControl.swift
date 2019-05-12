//
//  SegmentedControl.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 12.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class SegmentedControl : UISegmentedControl {

	var normalImages : [UIImage] = []
	var selectedImages : [UIImage] = []

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		selectedImages = [];
		normalImages = [];

		for idx in 0...self.numberOfSegments-1 {
			setImage(UIImage(named: "Dot")?.withRenderingMode(.alwaysOriginal), forSegmentAt: idx)
		}
	}
}
