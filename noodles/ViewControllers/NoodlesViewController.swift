//
//  NoodlesViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol FlowControlable: UIViewController {
	associatedtype ConcreteDirector

	var flowDelegate: ConcreteDirector! { get set }
}


class NoodlesViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(appMoveToBackground), name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillAppear(animated)
	}

	override func viewWillDisappear(_ animated: Bool) {

		viewWillDisappearOrMinimize()

		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillDisappear(animated)
	}

	@objc private func appMoveToBackground() {

		viewWillMinimize()
	}

	open func viewWillMinimize() {

		viewWillDisappearOrMinimize()
	}

	open func viewWillDisappearOrMinimize() {
	}
}
