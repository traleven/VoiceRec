//
//  Egg.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Simple audio file container that can be used to produce `Doughball`
@objc(Egg)
class Egg : PersistentObject {

	var name : String!
	var file : URL!
	var type : String!
	var idx : Int!

	class func fetch() -> [Egg] {

		let baseUrl = FileUtils.getDirectory("INBOX")
		return fetch(baseUrl)
	}

	class func fetch(_ path: URL?) -> [Egg] {
		guard (path != nil) else {
			return fetch()
		}

		guard let files = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		var data : [Egg] = []
		for url in files {

			let egg = Egg()
			egg.file = url
			egg.name = getName(for: url, of: url.pathExtension)
			egg.type = url.pathExtension
			egg.idx = data.count
			data.append(egg)
		}

		return data
	}

	class func getName(for file: URL, of type: String) -> String {
		switch type {
		case "":
			return file.lastPathComponent
		case "m4a":
			let attributes = try? FileManager.default.attributesOfItem(atPath: file.path)
			return "\((attributes?[FileAttributeKey.creationDate] as? Date)?.toString(withFormat: "yyyy-MM-dd HH:mm:ss") ?? "Recording")"
		case "txt":
			return (try? String(contentsOf: file)) ?? file.deletingPathExtension().lastPathComponent
		default:
			return file.deletingPathExtension().lastPathComponent
		}
	}
}
