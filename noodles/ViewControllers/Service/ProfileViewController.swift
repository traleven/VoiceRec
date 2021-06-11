//
//  ProfileViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 07.06.21.
//

import UIKit

protocol ProfileViewFlowDelegate : Director {
	typealias ModelRefreshHandle = (Model.User) -> Void
}

protocol ProfileViewControlDelegate : ProfileViewFlowDelegate {
	typealias RefreshHandle = () -> Void

	func selectRepetitionPattern(_ user: Model.User, _ refresh: ((Model.User) -> Void)?)
	func selectUserAvatar(_ user: Model.User, _ refresh: ((Model.User) -> Void)?)
}

class ProfileViewController: NoodlesViewController {
	private var flowDelegate: ProfileViewControlDelegate!

	private var content: Model.User

	private var nestedDelegates: [Any] = []

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

		let languagesDelegate = LanguagesTableController({ [weak self] in self?.content })
		nestedDelegates.append(languagesDelegate)
		languagesTableView.dataSource = languagesDelegate
		languagesTableView.delegate = languagesDelegate

		let tutorsDelegate = TutorsTableController({ [weak self] in self?.content })
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

		repetitionPattern.setAttributedTitle(NSAttributedString(string: content.sequence.dna), for: .normal)
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


	private func updateContent() {
	}


	@IBAction func selectRepetitionPattern() {

		flowDelegate.selectRepetitionPattern(content, refresh(_:))
	}


	@IBAction func selectAvatar() {

		flowDelegate.selectUserAvatar(content, refresh(_:))
	}
}

fileprivate class LanguagesTableController: NSObject {

	var user: () -> Model.User?

	init(_ user: @escaping () -> Model.User?) {
		self.user = user
	}
}

extension LanguagesTableController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let user = self.user()
		return user?.languages.count ?? 0
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let user = self.user() else { return UITableViewCell() }
		let language = user.languages[indexPath.row]
		let cellId = getCellIdentifier(for: language, of: user)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? LanguageCell
		if (cell == nil) {
			cell = LanguageCell()
		}
		cell?.prepare(for: language, of: user, at: indexPath.row)
		return cell!
	}


	private func getCellIdentifier(for language: Language, of user: Model.User) -> String {

		if user.base == language {
			return "language.base"
		} else if user.target == language {
			return "language.target"
		}
		return "language.generic"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}

extension LanguagesTableController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
	}
}

fileprivate class TutorsTableController: NSObject {

	var user: () -> Model.User?

	init(_ user: @escaping () -> Model.User?) {
		self.user = user
	}
}

extension TutorsTableController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let user = self.user() else { return UITableViewCell() }
		let tutors = user.tutors
		let tutor = indexPath.row < tutors.count ? tutors[indexPath.row] : nil
		let cellId = getCellIdentifier(for: tutor, of: user)

		var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TutorCell
		if (cell == nil) {
			cell = TutorCell()
		}
		cell?.prepare(for: tutor, of: user, at: indexPath.row)
		return cell!
	}


	private func getCellIdentifier(for tutor: Model.User?, of user: Model.User) -> String {

		if nil != tutor {
			return "tutor.generic"
		}
		return "tutor.empty"
	}


	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}

extension TutorsTableController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
	}
}
