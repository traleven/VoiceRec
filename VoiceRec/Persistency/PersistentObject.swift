//
//  PersistentObject.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class PersistentObject : GlobalIdentifiable {
	static var index: [String : URL] = [:]
	var id : String

	init() {

		id = UUID().uuidString
	}

	class func with(contentOf file: URL) -> Self? {
		return nil
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

	class func save<T: Encodable>(_ object: T, to file: URL) {
		var data: Data

		let encoder = JSONEncoder()
		do {
			data = try encoder.encode(object)
		} catch {
			fatalError("Couldn't serialize \(object) of \(T.self):\n\(error)")
		}

		do {
			try data.write(to: file, options: .atomicWrite)
		} catch {
			fatalError("Couldn't save \(file.path) from main bundle:\n\(error)")
		}
	}
}
