//
//  FileUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class FileUtils {

	class func getDocumentsDirectory() -> URL {

		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		FileUtils.ensureDirectory(documentsDirectory)
		return documentsDirectory
	}


	class func getDirectory(_ dir: String) -> URL {

		let documentsDirectory = getDocumentsDirectory()
		let targetDirectory = documentsDirectory.appendingPathComponent(dir, isDirectory: true)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getDirectory(_ dir: String, _ dir2: String) -> URL {

		let documentsDirectory = getDocumentsDirectory()
		let targetDirectory = documentsDirectory.appendingPathComponent(dir, isDirectory: true).appendingPathComponent(dir2)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func ensureDirectory(_ url: URL) {

		if (FileManager.default.fileExists(atPath:url.path)) {
			return
		}

		do {
			try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
		} catch let error {
			NSLog(error.localizedDescription)
		}
	}
}
