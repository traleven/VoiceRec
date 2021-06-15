//
//  Migration.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import Foundation

class Migration {

	static func migrateOutdated() {
		
		let versionFile = FileUtils.getDocumentsDirectory().appendingPathComponent("version.txt")
		let fileManager = FileManager.default
		var currentVersion = 0
		if fileManager.fileExists(atPath: versionFile.path) {
			do {
				let content = try Data(contentsOf: versionFile)
				let json = try JSONSerialization.jsonObject(with: content, options: [])
				let versionDictionary = json as! [String: Any]
				currentVersion = versionDictionary["dataVersion"] as! Int
			} catch {
			}
		}
		for idx in currentVersion..<migrations.count {
			migrations[idx]?()
		}

		let bundleInfo = Bundle.main.infoDictionary
		let version = bundleInfo?["CFBundleShortVersionString"] as? String ?? "Unknown"
		let build = bundleInfo?["CFBundleVersion"] as? String ?? "Unknown"
		let versionInfo: [String: Any] = [
			"applicationVersion": version,
			"applicationBuild": build,
			"dataVersion": migrations.count
		]
		if let output = OutputStream(url: versionFile, append: false) {
			output.open()
			JSONSerialization.writeJSONObject(versionInfo, to: output, options: .prettyPrinted, error: nil)
			output.close()
		}
	}

	static private let migrations: [Int: () -> Void] = [
		3: {
			DB.languages = LanguageDB(with: FileUtils.getDocumentsDirectory().appendingPathComponent("languages.json"), content: Language.supportedLanguages)
			DB.languages.flush()
		},
		2: {
			let fileManager = FileManager.default
			let musicDir = FileUtils.getDirectory(.music)
			let defaultMusicDir = FileUtils.getDefaultsDirectory(.music)

			guard let files = try? fileManager.contentsOfDirectory(at: defaultMusicDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
				fatalError("Migration failed")
			}

			for file in files {
				let filename = file.lastPathComponent
				let ext = file.pathExtension
				guard ext == "m4a" else {
					continue
				}

				try? fileManager.copyItem(at: file, to: musicDir.appendingPathComponent(filename))
			}
		},
		1: {
			let defaultUser = Model.User(
				id: FileUtils.getDirectory(.users).appendingPathComponent("me.json"),
				name: "New user",
				base: Language(withCode: "English"),
				target: Language(withCode: "Chinese")
			)
			defaultUser.save()
		},
		0: {
			let defaults = FileUtils.getDefaultsDirectory()
			let documents = FileUtils.getDocumentsDirectory()
			let fileManager = FileManager.default

			try? fileManager.removeItem(at: documents.appendingPathComponent("options.json"))
			try! fileManager.copyItem(
				at: defaults.appendingPathComponent("options.json"),
				to: documents.appendingPathComponent("options.json")
			)

			try? fileManager.removeItem(at: documents.appendingPathComponent("numerics.json"))
			try! fileManager.copyItem(
				at: defaults.appendingPathComponent("numerics.json"),
				to: documents.appendingPathComponent("numerics.json")
			)

			try? fileManager.removeItem(at: documents.appendingPathComponent("presets.json"))
			try! fileManager.copyItem(
				at: defaults.appendingPathComponent("presets.json"),
				to: documents.appendingPathComponent("presets.json")
			)
		},
	]
}
