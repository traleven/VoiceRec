//
//  Language.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class Language : NSObject {

	static var native = Language("English")

	var id : String

	init(_ id : String) {

		self.id = id
		super.init()
	}
}
