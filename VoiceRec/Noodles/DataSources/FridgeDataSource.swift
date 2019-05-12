//
//  Fridge.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 09.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import UIKit

class FridgeDataSource : NSObject, UITableViewDataSource {

	@IBInspectable var cellId: String = ""
	var data: [Egg] = []


	override init() {
		super.init()

		data = Egg.fetch().sorted { (lhv: Egg, rhv: Egg) -> Bool in
			return lhv.name > rhv.name
		}
	}


	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}


	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "UNUSED AUDIO"
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
