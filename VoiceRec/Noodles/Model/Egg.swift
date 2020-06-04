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
	var audioFile : URL!

	class func fetch() -> [Egg] {

		let baseUrl = FileUtils.getDirectory("INBOX")
		guard let files = try? FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		var data : [Egg] = []
		for url in files {
			
			let egg = Egg()
			egg.audioFile = url
			egg.name = url.lastPathComponent
			data.append(egg)
		}

		return data
	}
}
