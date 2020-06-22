//
//  Theme.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class Theme : PersistentObject {

	var name : String

	init(_ name : String) {

		self.name = name
		super.init()
	}

	required init(at: String) {
		name = ""
		super.init(at: at)
	}

	class func fetch() -> [Theme] {
		return [Theme("Travel"), Theme("Basketball"), Theme("Food")]
	}
}
