//
//  InboxViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 10.05.21.
//

import UIKit

protocol InboxListViewFlowDelegate : Director {
	func openInboxFolder(url: URL)
	func openTextEgg(url: URL)
	func addTextEgg()
}

class InboxListViewController : UIViewController {

	private var flowDelegate: InboxListViewFlowDelegate!
	private var url: URL
	private var current: Model.Egg?
	private var subitems: [URL] = []


	@IBOutlet var tableView: UITableView!


	override func viewDidLoad() {
		super.viewDidLoad()
	}


	override func viewWillAppear(_ animated: Bool) {
		current = Model.Egg(id: url)
		subitems = current!.children

		tableView.reloadData()
		self.title = current?.name

		super.viewWillAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
	}


	required init?(coder: NSCoder) {
		self.url = FileUtils.getDirectory(.inbox)
		super.init(coder: coder)

		let router = NavigationControllerRouter(controller: self.navigationController!)
		let director = InboxDirector(router: router)
		self.flowDelegate = director!
	}


	init?(coder: NSCoder, flow: InboxListViewFlowDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	@IBAction func recordNewAudio() {
		print("recordNewAudio")
	}


	@IBAction func writeNewMemo() {
		print("writeNewMemo")
		flowDelegate.addTextEgg()
	}
}


extension InboxListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subitems.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let egg = Model.Egg(id: subitems[indexPath.row])
		let cellId = getCellIdentifier(for: egg)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? InboxCell
		if (cell == nil) {
			cell = InboxCell()
		}
		cell?.prepare(for: egg)
		return cell!
	}


	private func getCellIdentifier(for egg: Model.Egg) -> String {
		switch egg.type {
		case .audio: return "inbox.audio"
		case .directory, .inbox: return "inbox.folder"
		case .text, .json: return "inbox.text"
		default:
			return "inbox.unknown"
		}
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
}


extension InboxListViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		//return super.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		//return super.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
		return nil
	}


	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		//super.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		flowDelegate.openInboxFolder(url: subitems[indexPath.row])
	}
}
