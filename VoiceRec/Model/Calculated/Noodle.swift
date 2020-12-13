//
//  Noodle.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// A specific sequence of audio from `Doughball`
/// repeated in accordance to a selected `Shape`
class Noodle {

	var dough : Phrase
	var shape : Shape

	init(_ dough : Phrase, shaped : Shape) {

		self.dough = dough
		self.shape = shaped
	}
}