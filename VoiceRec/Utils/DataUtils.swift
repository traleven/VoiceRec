//
//  DataUtils.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 23.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

extension Array  {

	func getRandom() -> Element? {

		if (self.count > 0) {
			let count = self.count
			return self[Int.random(in: 0...count-1)]
		}
		return nil
	}
}
