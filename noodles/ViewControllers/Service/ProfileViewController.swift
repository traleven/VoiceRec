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
}

class ProfileViewController: NoodlesViewController {
	private var flowDelegate: ProfileViewControlDelegate

	private var content: Model.User

	private var textDelegates: [Any] = []


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


	private func refresh(_ user: Model.User) {

		content = user
		refresh()
	}


	private func refresh() {
	}


	required init?(coder: NSCoder) {
		fatalError()
	}


	init?(coder: NSCoder, flow: ProfileViewControlDelegate, content: Model.User) {
		self.flowDelegate = flow
		self.content = content
		super.init(coder: coder)
	}


	private func updateContent() {
	}
}
