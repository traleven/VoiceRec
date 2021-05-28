//
//  LessonsListViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 27.05.21.
//

import UIKit

protocol LessonsListViewFlowDelegate : Director {
	func openInbox()
	func openPhrases()
}

class LessonsListViewController : UIViewController {

	private var flowDelegate: LessonsListViewFlowDelegate!
	private var url: URL
	private var items: [URL] = []


	@IBOutlet var tableView: UITableView!


	override func viewDidLoad() {
		super.viewDidLoad()
	}


	override func viewWillAppear(_ animated: Bool) {

		tableView.reloadData()

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
		let director = LessonsDirector(router: router)
		self.flowDelegate = director!
	}


	init?(coder: NSCoder, flow: LessonsListViewFlowDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	@IBAction func recordNewAudio() {
		print("recordNewAudio")
	}


	@IBAction func writeNewMemo() {
		print("writeNewMemo")
	}


	@IBAction func goToInbox() {
		flowDelegate.openInbox()
	}


	@IBAction func goToPhrases() {
		flowDelegate.openPhrases()
	}
}


extension LessonsListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let phrase = Model.Phrase(id: items[indexPath.row])
		let cellId = getCellIdentifier(for: phrase)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PhraseCell
		if (cell == nil) {
			cell = PhraseCell()
		}
		cell?.prepare(for: phrase)
		return cell!
	}


	private func getCellIdentifier(for egg: Model.Phrase) -> String {
		return "lesson.complete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
}


extension LessonsListViewController : UITableViewDelegate {

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
	}
}
