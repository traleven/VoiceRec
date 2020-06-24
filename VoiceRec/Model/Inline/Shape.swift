//
//  Shape.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// A specific sequence of Native and Foreign audio
/// repetiotions describing a "shape" of a `Noodle`
class Shape : Codable {

	var dna : String

	init(_ dna : String) {

		self.dna = dna
	}
}
