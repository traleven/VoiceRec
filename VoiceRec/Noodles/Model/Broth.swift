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
@objc(Broth)
class Broth : PersistentObject {

	var name : String!
	var audioFile : URL!

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

		let someAir = Broth()
		someAir.name = "some air"
		someAir.audioFile = Bundle.main.url(forResource: "some air", withExtension: "m4a")

		var data : [Broth] = [someAir]
		for url in files {
			let music = Broth()
			music.name = url.deletingPathExtension().lastPathComponent
			music.audioFile = url
			data.append(music)
		}

		return data
	}
}
