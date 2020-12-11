//
//  Egg.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Simple audio file container that can be used to produce `Doughball`
final class Egg : Equatable, GlobalIdentifiable {
	static func getBy(id: URL) -> Self? {
		return nil
	}

	static func == (lhs: Egg, rhs: Egg) -> Bool {
		return lhs.id == rhs.id
	}

	static var index : [URL : URL] = [:]

	var id : URL

	var name : String!
	var file : URL!
	var type : String!
	var idx : Int!

	required init(name: String, url: URL, ofType: String) {
		self.id = url
		self.name = name
		self.file = url
		self.type = ofType
	}

	class func with(contentOf file: URL) -> Self? {
		return .init(name: getName(for: file, of: file.pathExtension), url: file, ofType: file.pathExtension)
	}

	class func fetch() -> [Egg] {
		let baseUrl = FileUtils.getDirectory(.inbox)
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

			if let egg = Egg.with(contentOf: url) {
				egg.idx = data.count
				data.append(egg)
			}
		}

		return data
	}

	private class func getName(for file: URL, of type: String) -> String {
		switch type {
		case "":
			return findNameInChildren(for: file)
		case "m4a":
			let attributes = try? FileManager.default.attributesOfItem(atPath: file.path)
			return "\((attributes?[FileAttributeKey.creationDate] as? Date)?.toString(withFormat: "yyyy-MM-dd HH:mm:ss") ?? "Recording")"
		case "txt", "json":
			let content = (try? String(contentsOf: file)) ?? file.deletingPathExtension().lastPathComponent
			return content.count > 42 ? content.prefix(39).appending("...") : content
		default:
			return file.deletingPathExtension().lastPathComponent
		}
	}

	private class func findNameInChildren(for directory: URL) -> String {
		guard FileManager.default.fileExists(atPath: directory.path) else {
			return directory.lastPathComponent
		}
		guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [], options: .skipsHiddenFiles) else {
			return directory.lastPathComponent
		}
		guard let textFile = (files.first { (file: URL) -> Bool in
			file.pathExtension == "txt" || file.pathExtension == "json"
		}) else {
			return directory.lastPathComponent
		}

		return getName(for: textFile, of: textFile.pathExtension)
	}
}
