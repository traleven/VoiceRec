//
//  Shape.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit.UIColor

/// A specific sequence of Native and Foreign audio
/// repetiotions describing a "shape" of a `Noodle`
struct Shape : Codable {
	var dna : String
}

extension Shape {

	var colorCoded: NSAttributedString {
		let s = NSMutableAttributedString(string: dna)
		for range in (dna as NSString).range(ofAll: "B") {
			s.addAttribute(.foregroundColor, value: UIColor.errorText!, range: range)
		}
		return s
	}
}
