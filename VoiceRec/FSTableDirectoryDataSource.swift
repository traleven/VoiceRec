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
	var url: URL!
	var compose: Bool!

	init(url: URL) {
		self.url = url
		self.compose = false
	}
}


class FSTableDirectoryDataSource : NSObject, UITableViewDataSource {

	var baseUrl: URL
	var cellId: String
	var data: [DirectoryData]

	init(_ url: URL, withCellId: String) {

		baseUrl = url
		cellId = withCellId
		data = []

		do {

			let files = try FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)

			for url in files {
				let isDir = try url.resourceValues(forKeys: [.isDirectoryKey])
				if (isDir.isDirectory!) {
					data.append(DirectoryData(url: url))
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

		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? DirectoryCell
		cell?.setData(data[indexPath.row])
		return cell!
	}
}
