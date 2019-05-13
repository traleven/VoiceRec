//
//  LessonsDataSource.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 12.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class LessonsDataSource : NSObject, UITableViewDataSource {

	@IBInspectable var cellId: String = ""
	var data: [Recipe] = []


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: cellId)!
	}
}
