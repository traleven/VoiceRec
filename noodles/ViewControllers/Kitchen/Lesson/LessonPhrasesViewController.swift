//
//  LessonPhrasesViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonPhrasesViewFlowDelegate: Director {
	typealias ModelRefreshHandle = (Model.Recipe) -> Void

	func openMusicPage(_ lesson: Model.Recipe, _ refresh: @escaping ModelRefreshHandle) -> Bool
	func openExportPage(_ lesson: Model.Recipe, _ refresh: @escaping ModelRefreshHandle) -> Bool
}

protocol LessonPhrasesViewControlDelegate: LessonPhrasesViewFlowDelegate {
	typealias ModelRefreshHandle = (Model.Recipe) -> Void

	func selectPhrases(for lesson: Model.Recipe, _ refresh: @escaping ModelRefreshHandle)
	func createPhrase(for lesson: Model.Recipe, _ refresh: @escaping ModelRefreshHandle)
	func play(phrase: URL, of shape: Shape, with spices: Spices, progress: PlayerProgressCallback?, result: PlayerResultCallback?)
	func startLivePreview(_ lesson: Model.Recipe, with spices: Spices, _ onFinish: @escaping () -> Void)
	func stopLivePreview(_ lesson: Model.Recipe)
	func remove(phrase: URL, from lesson: Model.Recipe, _ refresh: ModelRefreshHandle)
	func save(_ lesson: Model.Recipe)
}

class LessonPhrasesViewController: NoodlesViewController {
	private var flowDelegate: LessonPhrasesViewControlDelegate!

	private var lesson: Model.Recipe
	private var delegates: [AnyObject] = []

	@IBOutlet var nameField: UITextField!
	@IBOutlet var tableView: UITableView!

	@IBOutlet var phraseCount: UILabel?
	@IBOutlet var durationLabel: UILabel?

	@IBOutlet var noMusicWarning: UIView?
	@IBOutlet var unusablePhrasesWarning: UIView?
	@IBOutlet var livePreviewGroup: UIView?

	@IBOutlet var languageButton: UIButton?


	override func viewDidLoad() {
		super.viewDidLoad()

		let nameTextFieldDelegate = ReturnKeyTextFieldDelegate({ [weak self] (result: String?) -> Bool in
			if let self = self {
				self.lesson.name = result ?? ""
			}
			return true
		})
		nameTextFieldDelegate.setOnEndEdit({ self.lesson.name = $0 ?? "" })
		nameField.delegate = nameTextFieldDelegate

		delegates.append(nameTextFieldDelegate)
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


	override func viewWillDisappearOrMinimize() {

		flowDelegate.stopLivePreview(lesson)
		super.viewWillDisappearOrMinimize()
	}

	override func viewWillDisappear(_ animated: Bool) {

		flowDelegate.save(lesson)
		super.viewWillDisappear(animated)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, flow: LessonPhrasesViewControlDelegate, lesson: Model.Recipe) {

		self.flowDelegate = flow
		self.lesson = lesson
		super.init(coder: coder)
	}


	private func refresh() {

		nameField.text = lesson.name
		phraseCount?.text = "\(lesson.phraseCount)"
		languageButton?.isSelected = !Settings.language.preferBase
		activateCorrectWarning()
		tableView.reloadData()
	}


	private func refresh(_ lesson: Model.Recipe) {

		self.lesson = lesson
		refresh()
	}


	private func activateCorrectWarning() {

		if lesson.music == nil {
			noMusicWarning?.isHidden = false
			unusablePhrasesWarning?.isHidden = true
			livePreviewGroup?.isHidden = true
		} else if lesson.contains(where: { !Model.Phrase(id: $0).isComplete }) {
			noMusicWarning?.isHidden = true
			unusablePhrasesWarning?.isHidden = false
			livePreviewGroup?.isHidden = true
		} else {
			noMusicWarning?.isHidden = true
			unusablePhrasesWarning?.isHidden = true
			livePreviewGroup?.isHidden = false
		}
	}


	@IBAction func selectPhrases() {

		flowDelegate.selectPhrases(for: lesson, refresh(_:))
	}


	@IBAction func createPhrase() {

		flowDelegate.createPhrase(for: lesson, refresh(_:))
	}


	@IBAction func toggleLivePreview(_ sender: UIControl) {

		if sender.isSelected {
			flowDelegate.stopLivePreview(lesson)
		} else {
			sender.isSelected = true
			flowDelegate.startLivePreview(lesson, with: lesson.spices) {
				sender.isSelected = false
			}
		}
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {

		Settings.language.preferBase.toggle()
		refresh()
	}


	@IBAction func goToMusicPage(_ sender: UIControl) {

		if !flowDelegate.openMusicPage(lesson, refresh(_:)) {
			sender.shake()
		}
	}


	@IBAction func goToExportPage(_ sender: UIControl) {

		if !flowDelegate.openExportPage(lesson, refresh(_:)) {
			sender.shake()
		}
	}
}

extension LessonPhrasesViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lesson.phraseCount
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let phrase = Model.Phrase(id: lesson[indexPath.row])
		let cellId = getCellIdentifier(for: phrase)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PhraseCell
		if (cell == nil) {
			cell = PhraseCell()
		}
		let preferBase = Settings.language.preferBase
		cell?.prepare(for: phrase, at: indexPath.row + 1, preferBaseLanguage: preferBase)
		return cell!
	}


	private func getCellIdentifier(for phrase: Model.Phrase) -> String {

		return phrase.isComplete ? "phrase.complete" : "phrase.incomplete"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}


extension LessonPhrasesViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let phrase = self.lesson[indexPath.row]
		var actions: [UIContextualAction] = []
		actions.addPlayAction { [unowned self] in
			flowDelegate.play(phrase: phrase, of: lesson.shape, with: lesson.spices, progress: nil, result: nil)
		}

		return makeConfiguration(fullSwipe: true, actions: actions)
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let phrase = self.lesson[indexPath.row]
		var actions: [UIContextualAction] = []
		actions.addDeleteAction(title: "Remove") { [unowned self] in
			flowDelegate.remove(phrase: phrase, from: lesson, refresh(_:))
		}

		return makeConfiguration(fullSwipe: false, actions: actions)
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		//let phrase = lesson[indexPath.row]
		//flowDelegate.openPhrase(phrase.id, refresh)
	}
}
