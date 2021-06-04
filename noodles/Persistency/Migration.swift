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
		}
	]
}
