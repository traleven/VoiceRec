//
//  FSTableDataSource.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit

struct AudioData {
	var url: URL!
	var audioPlayer: AudioPlayer?
	var compose: Bool!

	init(url: URL) {
		self.url = url
		self.audioPlayer = AudioPlayer(url)
		self.compose = false
	}
}


class FSTableAudioDataSource : NSObject, UITableViewDataSource {

	var baseUrl: URL
	var cellId: String
	var data: [AudioData]

	init(_ url: URL, withCellId: String) {

		baseUrl = url
		cellId = withCellId
		data = []

		do {

			let files = try FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)
			
			for url in files {
				data.append(AudioData(url: url))
			}

		} catch let error {

			NSLog(error.localizedDescription)
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? AudioCell
		cell?.setData(data[indexPath.row])
		return cell!
	}
}
