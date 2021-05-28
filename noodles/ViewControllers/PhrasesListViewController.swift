//
//  PhrasesListViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 27.05.21.
//

import UIKit

protocol PhrasesListViewFlowDelegate : Director {
	func openInbox()
	func openLessons()
}

class PhrasesListViewController : UIViewController {

	private var flowDelegate: PhrasesListViewFlowDelegate!
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
		let director = PhrasesDirector(router: router)
		self.flowDelegate = director!
	}


	init?(coder: NSCoder, flow: PhrasesListViewFlowDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	@IBAction func addNewPhrase() {
		print("addNewPhrase")
	}


	@IBAction func toggleLanguage() {
		print("toggleLanguage")
	}


	@IBAction func goToInbox() {
		flowDelegate.openInbox()
	}


	@IBAction func goToLessons() {
		flowDelegate.openLessons()
	}
}


extension PhrasesListViewController : UITableViewDataSource {

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
		return "phrase.complete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
}


extension PhrasesListViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}


	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
