//
//  NavigationControllerRouter.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

@objc class NavigationControllerRouter : NSObject {

	private var navigationController: UINavigationController!
	private var dismissHandlers: [UIViewController : (()->Void)?] = [:]

	init(controller: UINavigationController) {
		navigationController = controller
		super.init()
	}
}

extension NavigationControllerRouter : Router {
	@objc func push(_ viewController: UIViewController, onDismiss: (() -> Void)?) {
		dismissHandlers[viewController] = onDismiss
		navigationController.pushViewController(viewController, animated: true)
	}

	@objc func showModal(_ viewController: UIViewController, onDismiss: (() -> Void)?) {
		navigationController.present(viewController, animated: true) {
			onDismiss?()
		}
	}

	@objc func willDismiss(_ viewController: UIViewController) {
		let handler = dismissHandlers[viewController]
		handler??()
		dismissHandlers.removeValue(forKey: viewController)
	}
}
