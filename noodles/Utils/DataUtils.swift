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

extension Int {
	func toTimeString() -> String {
		if self < 0 {
			return "\(String(format: "%02d", (self + 1440) / 60)):\(String(format: "%02d", (self + 1440) % 60))"
		}
		if (self > 1440) {
			return "\(String(format: "%02d", (self - 1440) / 60)):\(String(format: "%02d", self % 60))"
		}
		return "\(String(format: "%02d", self / 60)):\(String(format: "%02d", self % 60))"
	}
}

extension Date {
	func toString(withFormat format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}

extension TimeInterval {
	func toMinutesTimeString() -> String {
		return String(format: "%02d:%02d", Int(self / 60), Int(self.remainder(dividingBy: 60)))
	}
}
