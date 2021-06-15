//
//  ProfileViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 07.06.21.
//

import UIKit

protocol ProfileViewFlowDelegate : Director {
	typealias ModelRefreshHandler = (Model.User) -> Void

	func editUserProfile(_ user: Model.User, _ refresh: ModelRefreshHandler?)
}

protocol ProfileViewControlDelegate : ProfileViewFlowDelegate & LanguagesTableControllerDelegate {
	typealias RefreshHandler = () -> Void
	typealias ModelRefreshHandler = (Model.User) -> Void

	func selectRepetitionPattern(_ user: Model.User, _ refresh: ModelRefreshHandler?)

	func setBaseLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func setTargetLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func deleteLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
}

class ProfileViewController: NoodlesViewController {
	private var flowDelegate: ProfileViewControlDelegate!

	private var content: Model.User

	private var nestedDelegates: [AnyObject] = []

	@IBOutlet var languagesTableView: UITableView!
	@IBOutlet var tutorsTableView: UITableView!

	@IBOutlet var avatar: UIImageView!
	@IBOutlet var avatarMask: UIImageView?
	@IBOutlet var name: UILabel!
	@IBOutlet var mail: UILabel!
	@IBOutlet var home: UILabel!
	@IBOutlet var location: UILabel!

	@IBOutlet var repetitionPattern: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()

		avatar.mask = avatarMask

		let languagesDelegate = LanguagesTableController(
			delegate: flowDelegate, readOnly: true,
			user: { [weak self] in self?.content },
			refresh: { [weak self] (user: Model.User) in self?.refresh(user) }
		)
		nestedDelegates.append(languagesDelegate)
		languagesTableView.dataSource = languagesDelegate
		languagesTableView.delegate = languagesDelegate

		let tutorsDelegate = TutorsTableController(
			user: { [weak self] in self?.content },
			refresh: { [weak self] (user: Model.User) in self?.refresh(user) }
		)
		nestedDelegates.append(tutorsDelegate)
		tutorsTableView.dataSource = tutorsDelegate
		tutorsTableView.delegate = tutorsDelegate
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		refreshFields()
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		refreshTables()
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

		avatar.image = content.icon ?? UIImage(systemName: "person.crop.circle")
		name.text = content.name
		mail.text = content.email
		home.text = content.from
		location.text = content.lives

		repetitionPattern.setAttributedTitle(content.sequence.colorCoded, for: .normal)
		repetitionPattern.setTitle(content.sequence.dna, for: .normal)
	}


	private func refreshTables() {

		languagesTableView.reloadData()
		tutorsTableView.reloadData()
	}


	required init?(coder: NSCoder) {
		self.content = Model.User.Me
		super.init(coder: coder)

		let router = NavigationControllerRouter(controller: self.navigationController!)
		let director = ProfileDirector(router: router)
		self.flowDelegate = director
	}


	init?(coder: NSCoder, flow: ProfileViewControlDelegate, content: Model.User) {
		self.flowDelegate = flow
		self.content = content
		super.init(coder: coder)
	}


	@IBAction func selectRepetitionPattern() {

		flowDelegate.selectRepetitionPattern(content, refresh(_:))
	}


	@IBAction func editProfile() {

		flowDelegate.editUserProfile(content, { self.content = $0 })
	}
}
