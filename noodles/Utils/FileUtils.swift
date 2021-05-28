//
//  FileUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class FileUtils {

	enum Directories : String {
		case inbox = "INBOX"
		case phrases = "Phrases"
		case lessons = "Lessons"
		case music = "Music"
		case users = "Users"
	}

	static let documentsDirectory: URL = getDocumentsDirectory()
	static let defaultsDirectory: URL = getDefaultsDirectory()

	class func getDocumentsDirectory() -> URL {

		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = URL.init(fileURLWithPath: ".", relativeTo: paths[0])
		FileUtils.ensureDirectory(documentsDirectory)
		return documentsDirectory
	}

	class func getDefaultsDirectory() -> URL {

		let resourcesDirectory = Bundle.main.resourceURL!
		let defaultsDirectory = resourcesDirectory.appendingPathComponent("DefaultData")
		return URL(fileURLWithPath: ".", relativeTo: defaultsDirectory)
	}


	class func getDirectory(_ dir: String) -> URL {

		let targetDirectory = documentsDirectory.appendingPathComponent(dir, isDirectory: true)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getDefaultsDirectory(_ dir: String) -> URL {

		let targetDirectory = defaultsDirectory.appendingPathComponent(dir, isDirectory: true)
		return targetDirectory
	}


	class func getDirectory(_ dir: String, _ dir2: String) -> URL {

		let targetDirectory = documentsDirectory.appendingPathComponent(dir, isDirectory: true).appendingPathComponent(dir2)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getDirectory(_ dir: Directories) -> URL {
		return getDirectory(dir.rawValue)
	}


	class func getDefaultsDirectory(_ dir: Directories) -> URL {
		return getDefaultsDirectory(dir.rawValue)
	}


	class func getTempFile(withExtension: String) -> URL {

		return FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: false).appendingPathExtension(withExtension)
	}


	class func getNewInboxFile(at path: URL, withName name: String, andExtension ext: String) -> URL {

		FileUtils.ensureDirectory(path)
		return path.appendingPathComponent(name + Date().toString(withFormat: "yyyyMMdd-HHmmss"), isDirectory: false).appendingPathExtension(ext)
	}


	class func getNewInboxFile(at path: URL, withExtension ext: String) -> URL {

		FileUtils.ensureDirectory(path)
		return path.appendingPathComponent(Date().toString(withFormat: "yyyyMMdd-HHmmss"), isDirectory: false).appendingPathExtension(ext)
	}


	class func getNewInboxFile(withName name: String, andExtension ext: String) -> URL {

		return getNewInboxFile(at: FileUtils.getDirectory(.inbox), withName: name, andExtension: ext)
	}


	class func get(file: String, withExtension: String, inDirectory: String) -> URL {

		return getDirectory(inDirectory).appendingPathComponent(file).appendingPathExtension(withExtension)
	}


	class func relativeContentsOfDirectory(_ url: URL) -> [URL] {
		let fmg = FileManager.default
		let filenames = (try? fmg.contentsOfDirectory(atPath: url.path)) ?? []
		let urls = filenames.map { (file: String) -> URL in
			url.appendingPathComponent(file)
		}
		return urls
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


	class func convertToDirectory(_ url: URL) -> URL {
		if (FileManager.default.fileExists(atPath: url.path) && !url.pathExtension.isEmpty) {
			ensureDirectory(url.deletingPathExtension())
			try! FileManager.default.moveItem(at: url, to: url.deletingPathExtension().appendingPathComponent(url.lastPathComponent))
		}
		return url.deletingPathExtension()
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

	class func PrepareDefaultData() {
		let filemgr = FileManager.default
		if !filemgr.fileExists(atPath: getDocumentsDirectory().appendingPathComponent(Directories.inbox.rawValue).path) {
			let resourcePath = getDefaultsDirectory()
			let documentsPath = getDocumentsDirectory()
			let propertyKeys : [URLResourceKey] = [.isDirectoryKey, .isReadableKey, .nameKey, .pathKey]
			do {
				for item in try filemgr.contentsOfDirectory(at: resourcePath, includingPropertiesForKeys: propertyKeys) {
					let destination = documentsPath.appendingPathComponent(item.lastPathComponent)
					if !filemgr.fileExists(atPath: destination.path) {
						try filemgr.copyItem(at: item, to: destination)
					}
				}
			}catch{
				print("Error for file write")
			}
		}
	}


	class func delete(_ url: URL) {
		let filemgr = FileManager.default
		guard filemgr.isDeletableFile(atPath: url.path) else {
			return
		}
		do {
			try filemgr.removeItem(atPath: url.path)
		} catch let error {
			NSLog("Failed to delete file at path \(url.path): \(error.localizedDescription)")
		}
	}
}