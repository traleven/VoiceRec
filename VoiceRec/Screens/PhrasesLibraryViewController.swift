//
//  PhrasesLibraryViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 03.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhrasesLibraryViewController: UITableViewController {

	var dataSource: FSTableDirectoryDataSource!
	var rootDirectory: URL?
	var parentData: DirectoryData?
	@IBInspectable var cellId: String!
	@IBInspectable var groupCellId: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		if rootDirectory == nil {
			rootDirectory = FileUtils.getDirectory(cellId)
		}
		refresh_data()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		refresh_data()
		NotificationCenter.default.addObserver(forName: .refreshPhrases, object: nil, queue: OperationQueue.main) { (notification: Notification) in
			//self.refresh_data()
			self.performSegue(withIdentifier: "phrase", sender: notification.object)
		}
	}


	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		NotificationCenter.default.removeObserver(self)
	}


	func refresh_data() {

		dataSource = FSTableDirectoryDataSource(rootDirectory!, parent: parentData, withCellId: cellId, andGroupCellId: groupCellId)
		tableView.dataSource = dataSource
		tableView.reloadData()
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "phrase",
			let dest = segue.destination as? PhraseDetailsViewController {
			if let idx = tableView.indexPathForSelectedRow,
				let cell = tableView.cellForRow(at: idx) as? PhraseCell {
				dest.setRootDirectory(cell.data!.url)
			} else if let senderUrl = sender as? URL {
				dest.setRootDirectory(senderUrl)
			}
		} else if segue.identifier == "subdirectory",
			let dest = segue.destination as? PhraseLibraryContainerViewController {
			if let idx = tableView.indexPathForSelectedRow,
				let cell = tableView.cellForRow(at: idx) as? DirectoryCell {
				dest.parentData = cell.data!
				dest.rootDirectory = cell.data!.url
			}
		}
	}
}
