//
//  PhrasesListViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 27.05.21.
//

import UIKit

protocol PhrasesListViewFlowDelegate : Director {
	typealias RefreshHandle = () -> Void

	func openInbox()
	func openLessons()
	func addNewPhrase(_ refresh: RefreshHandle?)
	func openPhrase(_ url: URL?, _ refresh: RefreshHandle?)
}


protocol PhrasesListViewControlDelegate : PhrasesListViewFlowDelegate {
	//func startRecording(to parent: Model.Egg?, progress: ((TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	//func stopRecording(_ refreshHandle: RefreshHandle)
	//func playAudioEgg(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	//func addTextEgg(to parent: Model.Egg?, _ refreshHandle: @escaping RefreshHandle)
	func delete(_ url: URL)
	//func share(_ egg: Model.Egg)
}


class PhrasesListViewController : UIViewController {

	private var flowDelegate: PhrasesListViewControlDelegate!
	private var items: [Model.Phrase] = []

	@IBOutlet var tableView: UITableView!
	@IBOutlet var flagButton: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()
	}


	override func viewWillAppear(_ animated: Bool) {
		refresh()

		super.viewWillAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
	}


	required init?(coder: NSCoder) {
		super.init(coder: coder)

		let router = NavigationControllerRouter(controller: self.navigationController!)
		let director = PhrasesDirector(router: router)
		self.flowDelegate = director!
	}


	init?(coder: NSCoder, flow: PhrasesListViewControlDelegate, id: URL) {
		self.flowDelegate = flow
		super.init(coder: coder)
	}


	private func refresh() {
		let fridge = Model.Fridge<Model.Phrase>(FileUtils.getDirectory(.phrases))
		items = fridge.fetch()
		tableView.reloadData()
	}


	@IBAction func addNewPhrase() {
		flowDelegate.addNewPhrase(refresh)
	}


	@IBAction func toggleLanguage() {
		Settings.language.preferBase.toggle()
		flagButton.isSelected = !Settings.language.preferBase
		refresh()
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
		let phrase = items[indexPath.row]
		let cellId = getCellIdentifier(for: phrase)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PhraseCell
		if (cell == nil) {
			cell = PhraseCell()
		}
		let preferBase = Settings.language.preferBase
		cell?.prepare(for: phrase, preferBaseLanguage: preferBase)
		return cell!
	}


	private func getCellIdentifier(for egg: Model.Phrase) -> String {
		return "phrase.complete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension PhrasesListViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let configuration = UISwipeActionsConfiguration(actions: [
			UIContextualAction(style: .destructive, title: "Delete", handler: { (action: UIContextualAction, view: UIView, handler: @escaping (Bool) -> Void) in

				let phrase = self.items[indexPath.row]
				self.flowDelegate.delete(phrase.id)
				self.refresh()

				handler(true)
			})
		])
		configuration.performsFirstActionWithFullSwipe = false
		return configuration
	}


	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let phrase = items[indexPath.row]
		flowDelegate.openPhrase(phrase.id, refresh)
	}
}
