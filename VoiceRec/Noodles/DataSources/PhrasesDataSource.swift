//
//  PhrasesDataSource.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 12.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhrasesDataSource : NSObject, UITableViewDataSource {

	@IBInspectable var cellId: String = ""
	var data: [Doughball] = []


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: cellId)!
	}
}
