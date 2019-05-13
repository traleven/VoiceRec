//
//  DynamicCell.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class DynamicCell<DataType>: UITableViewCell {

	@objc dynamic var data : Any? {
		didSet {
			onNewData(data as? DataType)
		}
	}


	func onNewData(_ newData : DataType?) {
	}
}
