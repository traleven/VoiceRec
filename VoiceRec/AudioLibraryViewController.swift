//
//  SecondViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 28.02.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class AudioLibraryViewController: UITableViewController {

	var dataSource: FSTableAudioDataSource!
	var rootDirectory: URL!
	@IBInspectable var cellId: String!

	override func viewDidLoad() {
		super.viewDidLoad()

		rootDirectory = FileUtils.getDirectory(cellId)
		refresh_data()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		refresh_data()
		NotificationCenter.default.addObserver(forName: .refreshMusic, object: nil, queue: OperationQueue.main) { (notification: Notification) in
			self.refresh_data()
		}
	}


	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		NotificationCenter.default.removeObserver(self)
	}


	func refresh_data() {

		dataSource = FSTableAudioDataSource(rootDirectory, withCellId: cellId)
		tableView.dataSource = dataSource
		tableView.reloadData()
	}

}
