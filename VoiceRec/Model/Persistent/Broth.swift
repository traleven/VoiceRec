//
//  Broth.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import CoreData

/// Background audio (music) used to add a specific "taste"
/// to the `Noodle`s in a `Bowl`
final class Broth : GlobalIdentifiable {
	static var index: [String : URL] = [:]

	var id: String
	var name : String!
	var audioFile : URL!

	required init(name: String, url: URL) {
		self.id = url.path
		self.name = name
		self.audioFile = url
	}

	static func getBy(id: String) -> Self? {
		return (index[id] != nil) ? Self.with(contentOf: index[id]!) : nil
	}

	static func with(contentOf file: URL) -> Self? {
		return .init(name: file.deletingPathExtension().lastPathComponent, url: file)
	}

	class func fetch() -> [Broth] {

		let baseUrl = FileUtils.getDirectory(.music)
		return fetch(baseUrl)
	}

	class func fetch(_ path: URL?) -> [Broth] {
		guard (path != nil) else {
			return fetch()
		}

		guard let files = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		let someAir = Broth(name: "some air", url: FileUtils.getDefaultsDirectory(.music).appendingPathComponent("some air.m4a"))

		var data : [Broth] = [someAir]
		for url in files {
			if let music = Broth.with(contentOf: url) {
				data.append(music)
			}
		}

		return data
	}
}
