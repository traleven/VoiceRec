//
//  LessonPhraseSelectorViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonPhraseSelectorViewFlowDelegate: Director {
	typealias ModelRefreshHandle = (Model.Recipe) -> Void

}

protocol LessonPhraseSelectorViewControlDelegate: LessonPhraseSelectorViewFlowDelegate {
	typealias ModelRefreshHandle = (Model.Recipe) -> Void

	func confirm(_ lesson: Model.Recipe, _ confirm: (Model.Recipe) -> Void)
}

class LessonPhraseSelectorViewController: NoodlesViewController {
	private var flowDelegate: LessonPhraseSelectorViewControlDelegate!
	private var confirmHandle: (Model.Recipe) -> Void

	private var lesson: Model.Recipe
	private var items: [Model.Phrase]

	@IBOutlet var flagButton: UIButton!
	@IBOutlet var tableView: UITableView!

	
	override func viewWillAppear(_ animated: Bool) {
		refresh()

		super.viewWillAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, flow: LessonPhraseSelectorViewControlDelegate, lesson: Model.Recipe, confirm: @escaping (Model.Recipe) -> Void) {
		self.flowDelegate = flow
		self.lesson = lesson
		self.confirmHandle = confirm

		let fridge = Model.Fridge<Model.Phrase>(FileUtils.getDirectory(.phrases))
		self.items = fridge.fetch()

		super.init(coder: coder)
	}


	private func refresh() {
		tableView.reloadData()
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {
		Settings.language.preferBase.toggle()
		refresh()
	}


	@IBAction func confirm() {
		flowDelegate.confirm(lesson, confirmHandle)
	}
}

extension LessonPhraseSelectorViewController: UITableViewDataSource {

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
		cell?.prepare(for: phrase, at: indexPath.row + 1, preferBaseLanguage: preferBase)
		cell?.accessoryType = lesson.contains(phrase.id) ? .checkmark : .none
		return cell!
	}


	private func getCellIdentifier(for phrase: Model.Phrase) -> String {

		return phrase.isComplete ? "phrase.complete" : "phrase.incomplete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}

extension LessonPhraseSelectorViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}


	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let phrase = items[indexPath.row]
		if lesson.contains(phrase.id) {
			lesson.removePhrase(id: phrase.id)
		} else {
			lesson.addPhrase(id: phrase.id)
		}
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}}
