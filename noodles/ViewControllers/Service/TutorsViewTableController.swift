//
//  TutorsViewTableController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 14.06.21.
//

import UIKit

class TutorsTableController: NSObject {

	var user: () -> Model.User?
	var refresh: (Model.User) -> Void

	init(user: @escaping () -> Model.User?, refresh: @escaping (Model.User) -> Void) {
		self.user = user
		self.refresh = refresh
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

		guard let user = self.user() else { return nil }
		let tutors = user.tutors
		guard indexPath.row < tutors.count else { return nil }

		var actions: [UIContextualAction] = []
		actions.addDeleteAction {
			print("Deleting tutor is not implemented yet")
		}
		return makeConfiguration(fullSwipe: true, actions: actions)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
	}
}
