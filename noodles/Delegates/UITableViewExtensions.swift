//
//  UITableViewExtensions.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 14.06.21.
//

import UIKit

extension Array where Element == UIContextualAction {

	mutating func addNormalAction(title: String, accent: Bool, _ handler: @escaping () -> Void) {

		addNormalAction(title: title, accent: accent) { () -> Bool in
			handler()
			return true
		}
	}

	mutating func addNormalAction(title: String, accent: Bool, _ handler: @escaping () -> Bool) {

		let action = UIContextualAction(style: .normal, title: title) { (_, _, result: (Bool) -> Void) in
			result(handler())
		}
		if accent {
			action.backgroundColor = .accentIcon
		}
		self.append(action)
	}

	mutating func addPlayAction(_ handler: @escaping () -> Void) {

		addNormalAction(title: "Play", accent: true, handler)
	}

	mutating func addPlayAction(_ handler: @escaping () -> Bool) {

		addNormalAction(title: "Play", accent: true, handler)
	}

	mutating func addDeleteAction(_ handler: @escaping () -> Void) {

		addDeleteAction(title: "Delete", { () -> Bool in
			handler()
			return true
		})
	}

	mutating func addDeleteAction(_ handler: @escaping () -> Bool) {

		addDeleteAction(title: "Delete", handler)
	}

	mutating func addDeleteAction(title: String, _ handler: @escaping () -> Void) {

		addDeleteAction(title: title, { () -> Bool in
			handler()
			return true
		})
	}

	mutating func addDeleteAction(title: String, _ handler: @escaping () -> Bool) {

		let action = UIContextualAction(style: .destructive, title: title) { (_, _, result: (Bool) -> Void) in
			result(handler())
		}
		action.backgroundColor = .errorIcon
		self.append(action)
	}
}

extension UITableViewDelegate {

	func makeConfiguration(fullSwipe: Bool, actions: [UIContextualAction]) -> UISwipeActionsConfiguration? {

		guard !actions.isEmpty else { return nil }

		let configuration = UISwipeActionsConfiguration(actions: actions)
		configuration.performsFirstActionWithFullSwipe = fullSwipe

		return configuration
	}
}
