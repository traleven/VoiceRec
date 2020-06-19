//
//  Doughball.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Annotated and translated phrase that can be used to produce `Noodle`
@objc(Doughball)
class Doughball : PersistentObject, Codable {

	var idx : Int = 0
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

	override init() {
		super.init()
		self.baseUrl = FileUtils.getDirectory(.phrases).appendingPathComponent("\(self.id).dough", isDirectory: true)
	}

	init(_ baseUrl: URL) {
		super.init()
		self.baseUrl = baseUrl
	}

	class func with(contentOf file: URL) -> Doughball {
		return load(file)
	}

	func save() {
		FileUtils.ensureDirectory(baseUrl)
		PersistentObject.save(self, to: baseUrl.appendingPathComponent("meta.json", isDirectory: false).path)
	}


	class func make(_ idx: Int, _ texts: Dictionary<String, String>) -> Doughball {
		let a = Doughball()
		a.idx = idx
		a.texts = texts
		return a
	}


	class func fetchDefault() -> [Doughball] {

		return [
			Doughball.make(0, ["English" : "A lot of people think I'm from the Middle East"]),
			Doughball.make(1, ["English" : "Altruistic"]),
			Doughball.make(2, ["English" : "At the end of the day, I just want to say that I care about you"]),
			Doughball.make(3, ["English" : "Axis of power"]),
			Doughball.make(4, ["English" : "Can I have a window seat?"]),
			Doughball.make(5, ["English" : "Grasp the sparrow's tail", "Chinese" : "揽雀尾"]),
			Doughball.make(6, ["English" : "Single whip", "Chinese" : "单鞭"]),
			Doughball.make(7, ["English" : "Brush a knee and push", "Chinese" : "搂膝拗步"]),
			Doughball.make(8, ["English" : "Play pipa", "Chinese" : "手挥琵琶"]),
		]
	}

	class func fetch() -> [Doughball] {

		let baseUrl = FileUtils.getDirectory(.phrases)
		return fetch(baseUrl)
	}

	class func fetch(_ path: URL?) -> [Doughball] {
		guard (path != nil) else {
			return fetch()
		}

		guard let files = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		var data : [Doughball] = []
		for url in files.filter({ (url: URL) -> Bool in url.pathExtension == "dough" }) {

			let dough = Doughball.with(contentOf: url.appendingPathComponent("meta.json"))
			dough.baseUrl = url
			dough.idx = data.count
			data.append(dough)
		}

		return data
	}
}
