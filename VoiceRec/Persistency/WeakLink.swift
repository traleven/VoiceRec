//
//  WeakLink.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

struct WeakLink<Element> {

	var item : Element

	init(_ item : Element) {
		self.item = item
	}
}
