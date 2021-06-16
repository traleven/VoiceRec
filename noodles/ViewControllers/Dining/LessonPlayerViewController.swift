//
//  LessonPlayerViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit

protocol LessonPlayerViewFlowDelegate: Director {
}

protocol LessonPlayerViewControlDelegate: LessonPlayerViewFlowDelegate {

	func startLesson(_ lesson: Model.Recipe, _ timer: ((TimeInterval) -> Void)?)
	func stopLesson()
	func isPlaying() -> Bool
}

class LessonPlayerViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.Recipe) -> Void

	private var flowDelegate: LessonPlayerViewControlDelegate!

	private var items: [Model.Recipe] = []
	private var lesson: Model.Recipe?

	@IBOutlet var lessonName: UILabel!
	@IBOutlet var phraseCount: UILabel?
	@IBOutlet var durationLabel: UILabel?

	@IBOutlet var languageButton: UIButton?

	override func viewWillAppear(_ animated: Bool) {
		reloadData()
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
		flowDelegate.stopLesson()
	}


	required init?(coder: NSCoder) {
		super.init(coder: coder)
		guard let navigationController = navigationController else { fatalError() }

		let router = NavigationControllerRouter(controller: navigationController)
		self.flowDelegate = LessonPlayerDirector(router: router)
	}


	init?(coder: NSCoder, flow: LessonPlayerViewControlDelegate) {

		self.flowDelegate = flow
		super.init(coder: coder)
	}


	private func reloadData() {

		let fridge = Model.Fridge<Model.Recipe>(FileUtils.getDirectory(.cooked))
		items = fridge.fetch(ctor: { Model.Recipe(id: $0, baked: true) })
	}


	private func refresh() {

		if nil == lesson { lesson = items.first }
		if let lesson = lesson, !flowDelegate.isPlaying() {
			lessonName.text = lesson.name
			phraseCount?.text = "\(lesson.phraseCount)"
			durationLabel?.text = "00:00"
		}
		languageButton?.setLanguageFlag(for: Model.User.Me)
	}


	private func refresh(_ lesson: Model.Recipe) {

		self.lesson = lesson
		refresh()
	}


	@IBAction func toggleLessonPlay(_ sender: UIControl) {

		if sender.isSelected {
			flowDelegate.stopLesson()
			sender.isSelected = false
			refresh()
		} else if let lesson = lesson {
			sender.isSelected = true
			flowDelegate.startLesson(lesson, { [weak self] (duration: TimeInterval) -> Void in
				self?.durationLabel?.text = duration.toMinutesTimeString()
			})
		}
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {

		Settings.language.preferBase.toggle()
		refresh()
	}
}

extension LessonPlayerViewController : UITableViewDataSource {

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
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension LessonPlayerViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

//		let lesson = items[indexPath.row]
//		var actions: [UIContextualAction] = []
//		actions.addPlayAction { [unowned self] () -> Void in
//			self.flowDelegate.startLivePreview(lesson)
//			self.refresh(lesson)
//		}
//		return makeConfiguration(fullSwipe: true, actions: actions)
		return nil
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

//		let lesson = items[indexPath.row]
//		var actions: [UIContextualAction] = []
//		return makeConfiguration(fullSwipe: true, actions: actions)
		return nil
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let lesson = items[indexPath.row]
		self.refresh(lesson)
	}
}
