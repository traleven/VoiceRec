//
//  EggDelegate.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 09.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class EggDelegate : NSObject, UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}


	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (UIContextualAction, UIView, (Bool) -> Void) in
			//noop
		})
		deleteAction.image = UIImage(named: "delete")

		let convertAction = UIContextualAction(style: .normal, title: ">", handler: { (UIContextualAction, UIView, (Bool) -> Void) in
			//noop
		})
		convertAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
		convertAction.image = UIImage(named: "share")

		let config = UISwipeActionsConfiguration(actions: [deleteAction, convertAction])
		config.performsFirstActionWithFullSwipe = false
		return config
	}
}
