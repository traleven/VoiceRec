//
//  Director.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

protocol Director {
	func willDismiss(_ viewController: UIViewController)
	func dismiss()
}

class DefaultDirector: NSObject, Director {

	var router: Router

	init(router: Router) {
		self.router = router
	}

	func willDismiss(_ viewController: UIViewController) {
		router.willDismiss(viewController)
	}

	func dismiss() {
		router.dismiss(animated: true, completion: nil)
	}
}
