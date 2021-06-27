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
	private static var storyboards: [String : UIStoryboard] = [:]

	init(router: Router) {
		self.router = router
	}

	func willDismiss(_ viewController: UIViewController) {
		router.willDismiss(viewController)
	}

	func dismiss() {
		router.dismiss(animated: true, completion: nil)
	}

	func makeLoadingViewController() -> UIViewController {
		let storyboard = getStoryboard(name: "Main", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "progress")
		return viewController
	}

	func getStoryboard(name: String, bundle: Bundle?) -> UIStoryboard {
		if let storyboard = Self.storyboards[name] {
			return storyboard
		}

		let storyboard = UIStoryboard(name: name, bundle: bundle)
		Self.storyboards[name] = storyboard
		return storyboard
	}
}
