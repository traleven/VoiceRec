//
//  ShareViewController.swift
//  import to inbox
//
//  Created by Ivan Dolgushin on 19.06.21.
//

import UIKit
import Social

class ShareViewController: UIViewController {

	fileprivate let m4aIdentifier = "public.mpeg-4-audio"
	private var items: [(NSItemProvider, URL?)] = []
	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let context = extensionContext else { return }
		let group = DispatchGroup()
		for item in context.inputItems as! [NSExtensionItem] {
			guard let attachments = item.attachments else { continue }

			for itemProvider in attachments {
				guard itemProvider.hasItemConformingToTypeIdentifier(m4aIdentifier) else { continue }
				group.enter()
				itemProvider.loadInPlaceFileRepresentation(forTypeIdentifier: m4aIdentifier) { (url, inPlace, error) in
					DispatchQueue.main.async { [self] in
						items.append((itemProvider, url))
						group.leave()
					}
				}
			}
		}
		group.notify(queue: .main) {
			self.tableView?.reloadData()
		}
	}


	@IBAction func cancel() {
		if let context = extensionContext {
			context.completeRequest(returningItems: [], completionHandler: nil)
		}
	}


	@IBAction func importToInbox() {

		let inboxRoot = FileUtils.getSharedDirectory(.inbox)
		importFiles(to: inboxRoot)
	}


    @IBAction func importMusic() {

		let musicRoot = FileUtils.getSharedDirectory(.music)
		importFiles(to: musicRoot)
    }

	
	private func importFiles(to directory: URL) {
		guard let context = extensionContext else { return }
		let group = DispatchGroup()
		for itemProvider in items {
			group.enter()
			itemProvider.0.loadFileRepresentation(forTypeIdentifier: m4aIdentifier) { (url, error) in
				DispatchQueue.main.async {
					if let url = url {
						_ = FileUtils.copy(url, to: directory.appendingPathComponent(url.lastPathComponent))
						group.leave()
					}
				}
			}
		}

		// Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
		group.notify(queue: .main) { [self] in
			context.completeRequest(returningItems: items, completionHandler: nil)
		}
	}
}

extension ShareViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let item = items[indexPath.row].1
		var cell = tableView.dequeueReusableCell(withIdentifier: "music.item") as? MusicCell
		if (cell == nil) {
			cell = MusicCell()
		}
		cell?.prepare(for: item!)
		return cell!
	}

}

extension ShareViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
