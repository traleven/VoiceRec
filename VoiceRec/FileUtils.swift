//
//  FileUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class FileUtils {

	static var documentsDirectory: URL = getDocumentsDirectory()

	class func getDocumentsDirectory() -> URL {

		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = URL.init(fileURLWithPath: ".", relativeTo: paths[0])
		FileUtils.ensureDirectory(documentsDirectory)
		return documentsDirectory
	}


	class func getDirectory(_ dir: String) -> URL {

		let targetDirectory = documentsDirectory.appendingPathComponent(dir, isDirectory: true)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getDirectory(_ dir: String, _ dir2: String) -> URL {

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


	class func isPhraseDirectory(_ url: URL) -> Bool {

		if FileManager.default.fileExists(atPath: url.appendingPathComponent("info.meta").path) {
			return true
		}
		// convertion code
		if FileManager.default.fileExists(atPath: url.appendingPathComponent("English.m4a").path)
			|| FileManager.default.fileExists(atPath: url.appendingPathComponent("Chinese.m4a").path) {
			FileManager.default.createFile(atPath: url.appendingPathComponent("info.meta").path, contents: nil)
			return true
		}
		// end of convertion code
		return false
	}


	class func makePhraseDirectory(_ phraseUrl: URL) {

		ensureDirectory(phraseUrl)
		if !isPhraseDirectory(phraseUrl) {

			do {
				try FileManager.default.createDirectory(at: phraseUrl, withIntermediateDirectories: true)
				let metaUrl = phraseUrl.appendingPathComponent("info.meta", isDirectory: false)
				FileManager.default.createFile(atPath: metaUrl.path, contents: nil)
				NotificationCenter.default.post(name: .refreshPhrases, object: phraseUrl)
			} catch let error {
				NSLog(error.localizedDescription)
			}
		}
	}
}
