//
//  FSTableDirectoryDataSource.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 03.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit

struct DirectoryData {
	var url: URL
	var relativePath: String
	var compose: Bool
	var preset: String
	var isPhrase: Bool

	init(url: URL, parent: DirectoryData?) {
		self.url = url
		self.relativePath = (parent?.relativePath.appending("/") ?? "").appending(url.lastPathComponent)
		self.preset = DB.phrases.getValue(forKey: self.relativePath)
		self.compose = self.preset != ""
		self.isPhrase = FileUtils.isPhraseDirectory(url)
	}
}


class FSTableDirectoryDataSource : NSObject, UITableViewDataSource {

	var baseUrl: URL
	var cellId: String
	var groupCellId: String?
	var data: [DirectoryData]

	init(_ url: URL, parent: DirectoryData?, withCellId: String, andGroupCellId: String?) {

		baseUrl = url
		cellId = withCellId
		groupCellId = andGroupCellId
		data = []

		do {

			let files = try FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)

			for url in files {
				let isDir = try url.resourceValues(forKeys: [.isDirectoryKey])
				if (isDir.isDirectory!) {
					data.append(DirectoryData(url: url, parent: parent))
				}
			}

		} catch let error {

			NSLog(error.localizedDescription)
		}
	}
	

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellData = data[indexPath.row]

		if !cellData.isPhrase && groupCellId != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId!) as? DirectoryCell
			cell?.setData(cellData)
			return cell!
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PhraseCell
		cell?.setData(cellData)
		return cell!
	}
}
