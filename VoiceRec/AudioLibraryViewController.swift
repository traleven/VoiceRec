//
//  SecondViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class AudioLibraryViewController: UITableViewController {

	var dataSource: FSTableDataSource!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		refresh_data()
	}

	func refresh_data() {

		dataSource = FSTableDataSource(FileUtils.getDocumentsDirectory(), withCellId: "recorder")
		tableView.dataSource = dataSource
		tableView.reloadData()
	}

}

