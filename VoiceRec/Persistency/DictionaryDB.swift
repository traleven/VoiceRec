//
//  DictionaryDB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DictionaryDB : DB {
	var data: Dictionary<String, String> = Dictionary()

	override init(withUrl: URL!) {
		super.init(withUrl: withUrl)

		do {
			let encoded = try Data(contentsOf: url, options: .mappedIfSafe)
			let decoder = JSONDecoder()
			data = try decoder.decode(Dictionary<String, String>.self, from: encoded)
		} catch let error {
			NSLog(error.localizedDescription)
		}
	}


	func setValue(forKey: String, value: String) {

		data[forKey] = value
	}


	func getValue(forKey: String) -> String {

		return data[forKey] ?? ""
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


	func getKeys(withValue: String) -> [String] {

		var result = [String]()
		for item in data {
			if (item.value == withValue) {
				result.append(item.key)
			}
		}
		return result
	}


	func getKeysWithValue() -> [String] {

		var result = [String]()
		for item in data {
			if (item.value != "") {
				result.append(item.key)
			}
		}
		return result
	}
}
