//
//  ZipUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 24.06.21.
//

import Foundation
import ZipArchive

class ZipUtils {

	class func zip(_ url: URL, file: String, _ finish: (URL?) -> Void) {

		let fm = FileManager.default

		let tmpUrl = try! fm.url(
			for: .itemReplacementDirectory,
			in: .userDomainMask,
			appropriateFor: url,
			create: true
		).appendingPathComponent(file)
		if SSZipArchive.createZipFile(atPath: tmpUrl.path, withContentsOfDirectory: url.path) {
			finish(tmpUrl)
			return
		}
		finish(nil)
	}


	class func unzip(_ archive: URL, destination: URL) -> Bool {

		FileUtils.ensureDirectory(destination)
		return SSZipArchive.unzipFile(atPath: archive.path, toDestination: destination.path)
	}
}
