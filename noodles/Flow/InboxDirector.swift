//
//  InboxDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

class InboxDirector: NSObject, Director {
	var router: Router!

	init?(router: Router) {
		self.router = router
	}

	func willDismiss(_ viewController: UIViewController) {
		router.willDismiss(viewController)
	}
}

extension InboxDirector: InboxListViewFlowDelegate {
	func openInboxFolder(url: URL) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "inbox.list", creator: { (coder: NSCoder) -> InboxListViewController? in
			return InboxListViewController(coder: coder, flow: self, id: url)
		})
		router.push(inboxViewController, onDismiss: nil)
	}

	func openTextEgg(url: URL) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "inbox.textedit", creator: { (coder: NSCoder) -> UIViewController? in
			return UIViewController(coder: coder)
		})
		router.present(inboxViewController, onDismiss: nil)
	}

	func addTextEgg() {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "inbox.textedit", creator: { (coder: NSCoder) -> UIViewController? in
			return UIViewController(coder: coder)
		})
		router.present(inboxViewController, onDismiss: nil)
	}
}
