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

	class func load<T: Decodable>(_ file: URL) -> T {
		let data: Data

		do {
			data = try Data(contentsOf: file)
		} catch {
			fatalError("Couldn't load \(file.path) from main bundle:\n\(error)")
		}

		do {
			let decoder = JSONDecoder()
			return try decoder.decode(T.self, from: data)
		} catch {
			fatalError("Couldn't parse \(file.path) as \(T.self):\n\(error)")
		}
	}

	class func save<T: Encodable>(_ object: T, to filename: String) {
		var data: Data

		let encoder = JSONEncoder()
		do {
			data = try encoder.encode(object)
		} catch {
			fatalError("Couldn't serialize \(object) of \(T.self):\n\(error)")
		}

		do {
			let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let file = dir.appendingPathComponent(filename)
			try data.write(to: file, options: .atomicWrite)
		} catch {
			fatalError("Couldn't save \(filename) from main bundle:\n\(error)")
		}
	}
}
