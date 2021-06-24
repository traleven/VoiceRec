//
//  FileUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

extension FileUtils {

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


	class func getConfigFile(_ file: String) -> URL {
		return getDocumentsDirectory().appendingPathComponent(file, isDirectory: false)
	}


	class func getConfigFile(_ file: Configs) -> URL {
		return getConfigFile(file.rawValue)
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


	class func getNewInboxFile(withExtension ext: String) -> URL {

		return getNewInboxFile(at: FileUtils.getDirectory(.inbox), withExtension: ext)
	}


	class func getNewPhraseId(at path: URL, withName name: String) -> URL {

		FileUtils.ensureDirectory(path)
		return path.appendingPathComponent("\(name).dough", isDirectory: true)
	}


	class func getNewPhraseId(at path: URL) -> URL {

		FileUtils.ensureDirectory(path)
		return path.appendingPathComponent("\(UUID().uuidString).dough", isDirectory: true)
	}


	class func getNewPhraseId(withName name: String) -> URL {

		return getNewPhraseId(at: FileUtils.getDirectory(.phrases), withName: name)
	}


	class func getNewPhraseId() -> URL {

		return getNewPhraseId(at: FileUtils.getDirectory(.phrases))
	}


	class func getNewLessonId(at path: URL) -> URL {

		FileUtils.ensureDirectory(path)
		return path.appendingPathComponent("\(UUID().uuidString).recipe", isDirectory: true)
	}


	class func getNewLessonId() -> URL {

		return getNewLessonId(at: FileUtils.getDirectory(.lessons))
	}


	class func get(file: String, withExtension: String, inDirectory: String) -> URL {

		return getDirectory(inDirectory).appendingPathComponent(file).appendingPathExtension(withExtension)
	}


	class func convertToDirectory(_ url: URL) -> URL {
		if (FileManager.default.fileExists(atPath: url.path) && !url.pathExtension.isEmpty) {
			ensureDirectory(url.deletingPathExtension())
			try! FileManager.default.moveItem(at: url, to: url.deletingPathExtension().appendingPathComponent(url.lastPathComponent))
		}
		return url.deletingPathExtension()
	}


	class func getMetaFile(for url: URL) -> URL {
		return url.appendingPathComponent("meta.json", isDirectory: false)
	}


	class func getNewPhraseFile(for url: URL, withExtension ext: String) -> URL {

		makePhraseDirectory(url)
		return url.appendingPathComponent("\(UUID().uuidString).\(ext)", isDirectory: false)
	}


	class func isLessonDirectory(_ url: URL) -> Bool {
		let fileManager = FileManager.default
		guard fileManager.fileExists(atPath: url.path) else { return false }

		let metaFile = getMetaFile(for: url)
		if fileManager.fileExists(atPath: metaFile.path) {
			return true
		}
		return false
	}


	class func isPhraseDirectory(_ url: URL) -> Bool {

		let fileManager = FileManager.default
		guard fileManager.fileExists(atPath: url.path) else { return false }

		let metaFile = getMetaFile(for: url)
		if fileManager.fileExists(atPath: metaFile.path) {
			return true
		}

		// convertion code
		if fileManager.fileExists(atPath: url.appendingPathComponent("English.m4a").path)
			|| fileManager.fileExists(atPath: url.appendingPathComponent("Chinese.m4a").path) {
			fileManager.createFile(atPath: getMetaFile(for: url).path, contents: nil)
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
				let metaUrl = getMetaFile(for: phraseUrl)
				FileManager.default.createFile(atPath: metaUrl.path, contents: nil)
				NotificationCenter.default.post(name: .refreshPhrases, object: phraseUrl)
			} catch let error {
				NSLog(error.localizedDescription)
			}
		}
	}


	class func makeLessonDirectory(_ lessonUrl: URL) {

		ensureDirectory(lessonUrl)
		if !isLessonDirectory(lessonUrl) {

			do {
				try FileManager.default.createDirectory(at: lessonUrl, withIntermediateDirectories: true)
				let metaUrl = getMetaFile(for: lessonUrl)
				FileManager.default.createFile(atPath: metaUrl.path, contents: nil)
				NotificationCenter.default.post(name: .refreshLessons, object: lessonUrl)
			} catch let error {
				NSLog(error.localizedDescription)
			}
		}
	}


	class func PrepareDefaultData() {
		let filemgr = FileManager.default
		if !filemgr.fileExists(atPath: getDirectory(.inbox).path) {
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
}
