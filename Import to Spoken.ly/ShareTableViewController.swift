//
//  ShareTableViewController.swift
//  Import to Spoken.ly
//
//  Created by Ivan Dolgushin on 14.04.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareTableViewController: UITableViewController {

	var data : [[URL?]]!

	func getLazyData() -> [[URL?]] {

		if (data != nil) {
			return data
		}

		data = []
		for extItem in self.extensionContext!.inputItems {
			let section = data.count
			data.append([])
			for attachment in (extItem as! NSExtensionItem).attachments! {
				let row = data[section].count
				data[section].append(nil)
				attachment.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: [:]) { (_ encodedData: NSSecureCoding?, _ error: Error?) in
					self.data[section][row] = encodedData as? URL
					self.tableView.reloadData()
				}
			}
		}
		return data
	}


	override func numberOfSections(in tableView: UITableView) -> Int {

		return self.extensionContext?.inputItems.count ?? 0
	}


	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		if self.numberOfSections(in: tableView) > 1 {
			let extensionItem : NSExtensionItem = self.extensionContext!.inputItems[section] as! NSExtensionItem
			return extensionItem.attributedTitle?.string ?? section.description
		}
		return nil
	}


	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		let extensionItem : NSExtensionItem = self.extensionContext!.inputItems[section] as! NSExtensionItem

		return extensionItem.attachments?.count ?? 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = (tableView.dequeueReusableCell(withIdentifier: "attachment") ?? ShareItemCell()) as! ShareItemCell
		cell.label?.text = getLazyData()[indexPath.section][indexPath.row]?.lastPathComponent
		return cell
	}
}
