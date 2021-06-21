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

protocol LessonsListViewControlDelegate : LessonsListViewFlowDelegate {
	func delete(_ lesson: Model.Recipe, _ refresh: (() -> Void)?)
}

class LessonsListViewController : NoodlesViewController {

	private var flowDelegate: LessonsListViewControlDelegate!
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


	init?(coder: NSCoder, flow: LessonsListViewControlDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	private func refresh() {
		languageButton?.setLanguageFlag(for: Model.User.Me)
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
		let lesson = items[indexPath.row]
		let cellId = getCellIdentifier(for: lesson)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? LessonCell
		if (cell == nil) {
			cell = LessonCell()
		}
		cell?.prepare(for: lesson)
		return cell!
	}


	private func getCellIdentifier(for lesson: Model.Recipe) -> String {
		return lesson.status == .complete ? "lesson.complete" : "lesson.incomplete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension LessonsListViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let item = items[indexPath.row]
		var actions: [UIContextualAction] = []
		actions.addDeleteAction { [unowned self] in
			self.flowDelegate.delete(item, refresh)
		}
		return makeConfiguration(fullSwipe: false, actions: actions)
	}

	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let lesson = items[indexPath.row]
		flowDelegate.openLesson(lesson)
	}
}
