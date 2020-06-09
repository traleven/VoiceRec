//
//  PersistentObject.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class PersistentObject : NSObject, Identifiable {

	var id : String

	override init() {

		id = UUID().uuidString
	}
}
