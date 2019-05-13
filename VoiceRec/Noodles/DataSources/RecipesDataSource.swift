//
//  RecipeDataSource.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class RecipesDataSource : NSObject, UITableViewDataSource {

	@IBInspectable var cellId: String = ""
	var data: [Recipe] = []


	override init() {
		data = Recipe.fetch()
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
