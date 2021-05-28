//
//  TableViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class TableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
}

extension TableViewController /*: UITableViewDelegate*/ {
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return UISwipeActionsConfiguration(actions: [
			UIContextualAction(style: .normal, title: "Play", handler: { (action: UIContextualAction, view: UIView, handler: @escaping (Bool) -> Void) in
				print("Play")
				handler(true)
			})
		])
	}

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return UISwipeActionsConfiguration(actions: [
			UIContextualAction(style: .normal, title: "Play", handler: { (action: UIContextualAction, view: UIView, handler: @escaping (Bool) -> Void) in
				print("Play")
				handler(true)
			})
		])
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "test") ?? UITableViewCell()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
}
