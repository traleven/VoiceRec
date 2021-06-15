//
//  ProfileEditorViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 07.06.21.
//

import UIKit

protocol ProfileEditorViewFlowDelegate : Director {
	typealias ModelRefreshHandler = (Model.User) -> Void
}

protocol ProfileEditorViewControlDelegate : ProfileEditorViewFlowDelegate & LanguagesTableControllerDelegate {
	typealias RefreshHandler = () -> Void
	typealias ModelRefreshHandler = (Model.User) -> Void

	func selectUserAvatar(_ user: Model.User, _ refresh: ModelRefreshHandler?)
	func selectRepetitionPattern(_ user: Model.User, _ refresh: ModelRefreshHandler?)

	func setBaseLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func setTargetLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func deleteLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func addLanguage(_ user: Model.User, _ refresh: ModelRefreshHandler?)

	func addTutor(_ user: Model.User, _ refresh: ModelRefreshHandler?)
}

class ProfileEditorViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.User?) -> Void

	private var flowDelegate: ProfileEditorViewControlDelegate
	private var content: Model.User
	private var onApply: ApplyHandle?

	private var textDelegates: [AnyObject] = []


	@IBOutlet var avatar: UIImageView!
	@IBOutlet var avatarMask: UIImageView?

	@IBOutlet var nameField: UITextField!
	@IBOutlet var emailField: UITextField!
	@IBOutlet var homeField: UITextField!
	@IBOutlet var locationField: UITextField!

	@IBOutlet var languageTable: UITableView!
	@IBOutlet var tutorsTable: UITableView!

	@IBOutlet var repetitionPattern: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()

		avatar.mask = avatarMask

		let languagesDelegate = LanguagesTableController(
			delegate: flowDelegate, readOnly: false,
			user: { [weak self] in self?.content },
			refresh: { [weak self] (user: Model.User) in self?.refresh(user) }
		)
		textDelegates.append(languagesDelegate)
		languageTable.dataSource = languagesDelegate
		languageTable.delegate = languagesDelegate

		let tutorsDelegate = TutorsTableController(
			user: { [weak self] in self?.content },
			refresh: { [weak self] (user: Model.User) in self?.refresh(user) }
		)
		textDelegates.append(tutorsDelegate)
		tutorsTable.dataSource = tutorsDelegate
		tutorsTable.delegate = tutorsDelegate

		nameField.delegate = textDelegates.retain(ReturnKeyTextFieldDelegate(
			onBeginEdit: {
			}, onEndEdit: { (result: String?) in
				if let result = result { self.content.name = result }
			}, onReturnKey: true
		))
		emailField.delegate = textDelegates.retain(ReturnKeyTextFieldDelegate(
			onBeginEdit: {
			}, onEndEdit: { (result: String?) in
				self.content.email = result
			}, onReturnKey: true
		))
		homeField.delegate = textDelegates.retain(ReturnKeyTextFieldDelegate(
			onBeginEdit: {
			}, onEndEdit: { (result: String?) in
				self.content.from = result
			}, onReturnKey: true
		))
		locationField.delegate = textDelegates.retain(ReturnKeyTextFieldDelegate(
			onBeginEdit: {
			}, onEndEdit: { (result: String?) in
				self.content.lives = result
			}, onReturnKey: true
		))
	}


	override func viewWillAppear(_ animated: Bool) {
		refreshFields()

		super.viewWillAppear(animated)
	}


	override func viewDidAppear(_ animated: Bool) {
		refreshTables()

		super.viewDidAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	private func refresh(_ user: Model.User) {

		content = user
		refresh()
	}


	private func refresh() {

		refreshFields()
		refreshTables()
	}


	private func refreshFields() {

		nameField.text = content.name
		emailField.text = content.email
		homeField.text = content.from
		locationField.text = content.lives
		repetitionPattern.setTitle(content.sequence.dna, for: .normal)
		repetitionPattern.setAttributedTitle(content.sequence.colorCoded, for: .normal)
	}


	private func refreshTables() {

		languageTable.reloadData()
		tutorsTable.reloadData()
	}


	required init?(coder: NSCoder) {
		fatalError()
	}


	init?(coder: NSCoder, flow: ProfileEditorViewControlDelegate, content: Model.User, applyHandle: ApplyHandle?) {
		self.flowDelegate = flow
		self.content = content
		self.onApply = applyHandle
		super.init(coder: coder)
	}


	@IBAction func selectAvatar() {

		flowDelegate.selectUserAvatar(content, refresh(_:))
	}


	@IBAction func selectRepetitionPattern() {

		flowDelegate.selectRepetitionPattern(content, refresh(_:))
	}


	@IBAction func addLanguage() {

		flowDelegate.addLanguage(content, refresh(_:))
	}


	@IBAction func addTutor() {

		flowDelegate.addTutor(content, refresh(_:))
	}


	@IBAction func save() {

		onApply?(content)
	}


	@IBAction func cancel() {

		onApply?(nil)
	}
}
