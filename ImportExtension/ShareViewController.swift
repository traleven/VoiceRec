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
	fileprivate let oggIdentifier = "org.xiph.oga"
	
	private var items: [(NSItemProvider, URL?)] = []
	private var inputItems: [NSExtensionItem] = []
	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		DispatchQueue.main.setSpecific(key: DispatchSpecificKey<Bool>(), value: true)
		guard let context = extensionContext else { return }
		let group = DispatchGroup()
		let loadCompletionHandler = { [unowned self] (item: NSItemProvider, url: URL?) -> Void in
			DispatchQueue.syncToMain {
				items.append((item, url))
			}
		}
		for item in context.inputItems as! [NSExtensionItem] {
			guard let attachments = item.attachments else { continue }

			for itemProvider in attachments {
				if loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: m4aIdentifier, loadCompletionHandler)
					|| loadInPlaceRepresentation(group: group, itemProvider: itemProvider, uti: oggIdentifier, loadCompletionHandler) {

					inputItems.append(item)
				}
			}
		}
		group.notify(queue: .main) {
			self.tableView?.reloadData()
		}
	}


	private func loadInPlaceRepresentation(group: DispatchGroup, itemProvider: NSItemProvider, uti: String, _ completionHandler: @escaping (NSItemProvider, URL?) -> Void) -> Bool {
		guard itemProvider.hasItemConformingToTypeIdentifier(uti) else { return false }

		group.enter()
		itemProvider.loadInPlaceFileRepresentation(forTypeIdentifier: uti) { (url, inPlace, error) in
			completionHandler(itemProvider, url)
			DispatchQueue.main.async {
				group.leave()
			}
		}
		return true
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
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: m4aIdentifier, {
				if let url = $0 {
					_ = FileUtils.copy(url, to: directory)
				}
			}) {
				continue
			}
			if loadFileRepresentation(group: group, itemProvider: itemProvider.0, uti: oggIdentifier, {
				if let url = $0 {
					importAudio(ogg: url, m4a: directory.appendingPathComponent("\(UUID().uuidString).m4a"))
				}
			}) {
				continue
			}
			print("Unsupported attachment format for: \(itemProvider)")
		}

		// Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
		group.notify(queue: .main) { [self] in
			context.completeRequest(returningItems: inputItems, completionHandler: nil)
		}
	}


	private func loadFileRepresentation(group: DispatchGroup, itemProvider: NSItemProvider, uti: String, _ completionHandler: @escaping (URL?) -> Void) -> Bool {
		guard itemProvider.hasItemConformingToTypeIdentifier(uti) else { return false }

		group.enter()
		itemProvider.loadFileRepresentation(forTypeIdentifier: uti) { (url, error) in
			if let error = error { print(error) }
			completionHandler(url)
			DispatchQueue.main.async {
				group.leave()
			}
		}
		return true
	}
}

fileprivate func importAudio(ogg source: URL, m4a destination: URL) {
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

/*
SUBQUERY(
	extensionItems,
	$extensionItem,
	SUBQUERY(
		$extensionItem.attachments,
		$attachment,
		ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.mpeg-4-audio"
		|| ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "org.xiph.oga"
	).@count > 0
).@count > 0
*/
