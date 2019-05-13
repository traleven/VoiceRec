//
//  ThemesDataSource.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 12.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class ThemesDataSource : NSObject, UITableViewDataSource {

	@IBInspectable var cellId: String = ""
	var data: [Theme] = []


	override init() {
		data = Theme.fetch()
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
		cell?.setValue(data[indexPath.row], forKey: "data")
		return cell!
	}
}
