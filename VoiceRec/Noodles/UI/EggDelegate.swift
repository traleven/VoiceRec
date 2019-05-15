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

		let deleteAction = UIContextualAction(style: .destructive, title: "", handler: { (UIContextualAction, UIView, (Bool) -> Void) in
			//noop
		})
		deleteAction.backgroundColor = UIColor(named: "red")
		deleteAction.image = UIImage(named: "delete_small")

		let convertAction = UIContextualAction(style: .normal, title: "", handler: { (UIContextualAction, UIView, (Bool) -> Void) in
			//noop
		})
		convertAction.backgroundColor = UIColor(named: "grey-med")
		convertAction.image = UIImage(named: "multiselect_small")

		let config = UISwipeActionsConfiguration(actions: [deleteAction, convertAction])
		config.performsFirstActionWithFullSwipe = false
		return config
	}


	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
		headerView.backgroundColor = UIColor(named: "grey-light")

		let title = NSMutableAttributedString(string: "UNUSED AUDIO")
		title.addAttribute(NSAttributedString.Key.kern, value: 0.5, range: NSMakeRange(0, title.length))

		let label = UILabel(frame: CGRect(x: 12.5, y: 0, width: headerView.frame.width - 25, height: 30))
		label.attributedText = title
		label.textColor = UIColor(named: "grey-med")
		label.font = label.font.withSize(13)
		headerView.addSubview(label)

		let separator = UILabel(frame: CGRect(x: 0, y: 28, width: headerView.frame.width, height: 0.5))
		separator.backgroundColor = UIColor(named: "grey-med")
		headerView.addSubview(separator)

		return headerView
	}
}
