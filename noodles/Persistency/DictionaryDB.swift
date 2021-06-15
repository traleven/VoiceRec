//
//  DictionaryDB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DictionaryDB<ValueType> : DB where ValueType : Codable & Equatable {
	var data: Dictionary<String, ValueType> = Dictionary()
	let defaultValue : ValueType

	init(with url: URL!, andDefaultValue defaultValue: ValueType) {
		self.defaultValue = defaultValue
		super.init(with: url)

		do {
			let encoded = try Data(contentsOf: url, options: .mappedIfSafe)
			let decoder = JSONDecoder()
			data = try decoder.decode(Dictionary<String, ValueType>.self, from: encoded)
		} catch let error {
			NSLog(error.localizedDescription)
		}
	}


	func setValue(forKey: String, value: ValueType) {

		data[forKey] = value
	}


	func getValue(forKey: String) -> ValueType {

		return data[forKey] ?? defaultValue
	}


	subscript(_ key: String) -> ValueType {
		return getValue(forKey: key)
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


	func getKeys(withValue: ValueType) -> [String] {

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
			if (item.value != defaultValue) {
				result.append(item.key)
			}
		}
		return result
	}

	override var debugDescription: String {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let encoded = try encoder.encode(data)
			return String(data: encoded, encoding: .utf8) ?? super.debugDescription
		} catch let error {
			NSLog(error.localizedDescription)
		}
		return super.debugDescription
	}

	var rawContent : String { return (try? String(contentsOf: url)) ?? "File not found" }
}
