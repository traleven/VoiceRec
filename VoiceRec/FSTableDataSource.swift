//
//  FSTableDataSource.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit

class FSTableDataSource : NSObject, UITableViewDataSource {

	var baseUrl: URL
	var cellId: String
	var files: [URL]

	init(_ url: URL, withCellId: String) {

		baseUrl = url
		cellId = withCellId

		do {

			files = try FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)

		} catch let error {

			NSLog(error.localizedDescription)
			files = []
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return files.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? AudioCell
		cell?.setData(files[indexPath.row])
		return cell!
	}
}
