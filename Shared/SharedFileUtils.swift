//
//  SharedFileUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 19.06.21.
//

import Foundation

class FileUtils {

	enum Directories : String {
		case inbox = "INBOX"
		case phrases = "Phrases"
		case lessons = "Lessons"
		case music = "Music"
		case cooked = "Cooked"
		case users = "Users"
	}

	enum Configs : String {
		case options = "options.json"
		case numerics = "numerics.json"
		case presets = "presets.json"
		case languages = "languages.json"
		case proficiencies = "proficiencies.json"
	}

	static let sharedDirectory: URL = getSharedDirectory()
	private static let groupIdentifier = "group.com.dolgushyn.spokenly.import"

	class func getSharedDirectory() -> URL {

		let fileManager = FileManager.default
		let root = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
		return URL.init(fileURLWithPath: ".", relativeTo: root)
	}

	class func getSharedDirectory(_ dir: String) -> URL {

		let targetDirectory = sharedDirectory.appendingPathComponent(dir, isDirectory: true)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getSharedDirectory(_ dir: String, _ dir2: String) -> URL {

		let targetDirectory = sharedDirectory.appendingPathComponent(dir, isDirectory: true).appendingPathComponent(dir2)
		FileUtils.ensureDirectory(targetDirectory)
		return targetDirectory
	}


	class func getSharedDirectory(_ dir: Directories) -> URL {
		return getSharedDirectory(dir.rawValue)
	}


	class func getTempFile(withExtension: String) -> URL {

		return FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: false).appendingPathExtension(withExtension)
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


	class func delete(_ url: URL) {
		let filemgr = FileManager.default
		guard filemgr.isDeletableFile(atPath: url.path) else {
			return
		}
		guard filemgr.fileExists(atPath: url.path) else {
			return
		}
		do {
			try filemgr.removeItem(atPath: url.path)
		} catch let error {
			NSLog("Failed to delete file at path \(url.path): \(error.localizedDescription)")
		}
	}


	/// Copy a `source` file to the `directory`, keep the file name
	class func copy(_ source: URL, to directory: URL) -> URL? {

		return copy(source, to: directory, as: source.lastPathComponent)
	}

	/// Copy a `source` file to the `directory` as a file named `filename`
	class func copy(_ source: URL, to directory: URL, as filename: String) -> URL? {

		let fileManager = FileManager.default
		let targetFile = directory.appendingPathComponent(filename)
		ensureDirectory(directory)
		do {
			try fileManager.copyItem(at: source, to: targetFile)
		} catch let error {
			NSLog("Failed to copy \(source) to \(directory) as \(filename): \(error)")
			return nil
		}
		return targetFile
	}


	/// Copy a `source` file to the `directory`, keep the file name, but if it already exists at destination then change it to `filename`
	class func copy(_ source: URL, to directory: URL, fallback filename: String) -> URL? {

		let fileManager = FileManager.default
		let originalName = source.lastPathComponent
		let targetFile = directory.appendingPathComponent(originalName)
		let exists = fileManager.fileExists(atPath: targetFile.path)
		return copy(source, to: directory, as: exists ? filename : originalName)
	}


	/// Move a `source` file to the `directory`, keep the file name
	class func move(_ source: URL, to directory: URL) -> URL? {

		return move(source, to: directory, as: source.lastPathComponent)
	}


	/// Move a `source` file to the `directory` as a file named `filename`
	class func move(_ source: URL, to directory: URL, as filename: String) -> URL? {

		let fileManager = FileManager.default
		let targetFile = directory.appendingPathComponent(filename)
		ensureDirectory(directory)
		do {
			try fileManager.moveItem(at: source, to: targetFile)
		} catch let error {
			NSLog("Failed to copy \(source) to \(directory) as \(filename): \(error)")
			return nil
		}
		return targetFile
	}
}
