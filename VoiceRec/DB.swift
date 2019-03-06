//
//  DB.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class DB: NSObject {

	static var phrases: DB! = DB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("phrases.db", isDirectory: false))

	static var music: DB! = DB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("music.db", isDirectory: false))

	static var options: DB! = DB(withUrl: FileUtils.getDocumentsDirectory().appendingPathComponent("options.db", isDirectory: false))

	var data: Dictionary<String, String> = Dictionary()
	var url: URL!

	init(withUrl: URL!) {
		super.init()

		url = withUrl

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


	func flush() {

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
}
