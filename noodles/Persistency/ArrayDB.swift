//
//  ArrayDB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class ArrayDB : DB {
	var data: Array<String> = Array()

	override init(withUrl: URL!) {
		super.init(withUrl: withUrl)

		do {
			let encoded = try Data(contentsOf: url, options: .mappedIfSafe)
			let decoder = JSONDecoder()
			data = try decoder.decode(Array<String>.self, from: encoded)
		} catch let error {
			NSLog(error.localizedDescription)
		}
	}

	subscript(_ idx: Int) -> String {
		data[idx]
	}

	override func flush() {

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let encoded = try encoder.encode(data)
			try encoded.write(to: url, options: .atomicWrite)
		} catch let error {
			NSLog(error.localizedDescription)
		}
	}
}

extension ArrayDB: Collection {
	var startIndex: Int { data.startIndex }
	var endIndex: Int { data.endIndex }

	func index(after i: Int) -> Int { i + 1 }
}
