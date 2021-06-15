//
//  LanguagesViewTableController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 14.06.21.
//

import UIKit

protocol LanguagesTableControllerDelegate {
	typealias ModelRefreshHandler = (Model.User) -> Void

	func selectProficiency(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func setBaseLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func setTargetLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
	func deleteLanguage(_ user: Model.User, language: Language, _ refresh: ModelRefreshHandler?)
}

class LanguagesTableController: NSObject {

	var user: () -> Model.User?
	let refresh: (Model.User) -> Void
	let flowDelegate: LanguagesTableControllerDelegate
	let readOnly: Bool

	init(
		delegate: LanguagesTableControllerDelegate,
		readOnly: Bool,
		user: @escaping () -> Model.User?,
		refresh: @escaping (Model.User) -> Void
	) {
		self.flowDelegate = delegate
		self.user = user
		self.refresh = refresh
		self.readOnly = readOnly
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

		guard let user = self.user() else { return nil }
		let language = user.languages[indexPath.row]

		var actions: [UIContextualAction] = []
		if !readOnly && language != user.base {
			actions.addNormalAction(title: "Make Base", accent: true) { [unowned self] in
				flowDelegate.setBaseLanguage(user, language: language, refresh)
			}
		}
		if language != user.target {
			actions.addNormalAction(title: "Make Target", accent: true) { [unowned self] in
				flowDelegate.setTargetLanguage(user, language: language, refresh)
			}
		}
		if !readOnly && user.languages.count > 2 && language != user.base && language != user.target {
			actions.addDeleteAction { [unowned self] in
				flowDelegate.deleteLanguage(user, language: language, refresh)
			}
		}
		return makeConfiguration(fullSwipe: false, actions: actions)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		guard !readOnly, let user = self.user() else { return }
		let language = user.languages[indexPath.row]

		flowDelegate.selectProficiency(user, language: language, refresh)
	}
}
