//
//  Phrase.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Annotated and translated phrase that can be used to produce `Noodle`
final class Phrase : PersistentObject, Codable {

	var baseUrl : URL = FileUtils.getDirectory(.phrases)
	var audioFiles : Dictionary<String, URL> = [:]
	var texts : Dictionary<String, String> = [:]
	var comment : String = ""

	var baseText : String? {
		get { texts[Settings.language.base] }
	}

	var targetText : String? {
		get { texts[Settings.language.target] }
	}

	var baseAudio : URL? {
		get { audioFiles[Settings.language.base] }
	}

	var targetAudio : URL? {
		get { audioFiles[Settings.language.target] }
	}

	override init() {
		super.init()
		self.baseUrl = FileUtils.getDirectory(.phrases).appendingPathComponent("\(self.id).dough", isDirectory: true)
	}

	init(_ baseUrl: URL) {
		super.init()
		self.baseUrl = baseUrl
	}

	override class func with(contentOf file: URL) -> Self? {
		return load(file)
	}

	func save() {
		FileUtils.ensureDirectory(baseUrl)
		PersistentObject.save(self, to: FileUtils.getMetaFile(for: baseUrl))
	}


	class func make(_ idx: Int, _ texts: Dictionary<String, String>) -> Phrase {
		let a = Phrase()
		a.texts = texts
		return a
	}

	class func fetch() -> [Phrase] {

		let baseUrl = FileUtils.getDirectory(.phrases)
		return fetch(baseUrl)
	}

	class func fetch(_ path: URL?) -> [Phrase] {
		guard (path != nil) else {
			return fetch()
		}

		guard let files = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		var data : [Phrase] = []
		for url in files.filter({ (url: URL) -> Bool in url.pathExtension == "dough" }) {

			if let dough = Phrase.with(contentOf: FileUtils.getMetaFile(for: url)) {
				dough.baseUrl = url
				data.append(dough)
			}
		}

		return data
	}
}
