//
//  ProfileEditorViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 07.06.21.
//

import UIKit

protocol ProfileEditorViewFlowDelegate : Director {
	typealias ModelRefreshHandle = (Model.User) -> Void
}

protocol ProfileEditorViewControlDelegate : ProfileEditorViewFlowDelegate {
	typealias RefreshHandle = () -> Void
}

class ProfileEditorViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.User?) -> Void

	private var flowDelegate: ProfileEditorViewControlDelegate
	private var content: Model.User
	private var onApply: ApplyHandle?

	private var textDelegates: [Any] = []


	override func viewWillAppear(_ animated: Bool) {
		refresh()

		super.viewWillAppear(animated)
	}


	override func viewWillDisappearOrMinimize() {
		updateContent()
		save()

		super.viewWillDisappearOrMinimize()
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


	init?(coder: NSCoder, flow: ProfileEditorViewControlDelegate, content: Model.User, applyHandle: ApplyHandle?) {
		self.flowDelegate = flow
		self.content = content
		self.onApply = applyHandle
		super.init(coder: coder)
	}


	private func updateContent() {
	}


	@IBAction func save() {

		updateContent()
		onApply?(content)
	}
}
