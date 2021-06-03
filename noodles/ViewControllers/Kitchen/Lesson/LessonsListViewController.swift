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
	func openLesson(_ lesson: Model.Recipe?)
}

class LessonsListViewController : NoodlesViewController {

	private var flowDelegate: LessonsListViewFlowDelegate!
	private var url: URL
	private var items: [Model.Recipe] = []


	@IBOutlet var tableView: UITableView!
	@IBOutlet var languageButton: UIButton?


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
		super.willMove(toParent: parent)
	}


	required init?(coder: NSCoder) {
		self.url = FileUtils.getDirectory(.lessons)
		super.init(coder: coder)

		let router = NavigationControllerRouter(controller: self.navigationController!)
		let director = LessonsDirector(router: router)
		self.flowDelegate = director
	}


	init?(coder: NSCoder, flow: LessonsListViewFlowDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	private func refresh() {
		languageButton?.isSelected = !Settings.language.preferBase
		let fridge = Model.Fridge<Model.Recipe>(FileUtils.getDirectory(.lessons))
		items = fridge.fetch()
		tableView.reloadData()
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {
		Settings.language.preferBase.toggle()
		refresh()
	}


	@IBAction func goToInbox() {
		flowDelegate.openInbox()
	}


	@IBAction func goToPhrases() {
		flowDelegate.openPhrases()
	}

	@IBAction func addNewLesson() {
		flowDelegate.openLesson(nil)
	}
}


extension LessonsListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let phrase = items[indexPath.row]
		let cellId = getCellIdentifier(for: nil)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? LessonCell
		if (cell == nil) {
			cell = LessonCell()
		}
		cell?.prepare(for: phrase)
		return cell!
	}


	private func getCellIdentifier(for lesson: Any?) -> String {
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
		let lesson = items[indexPath.row]
		flowDelegate.openLesson(lesson)
	}
}
