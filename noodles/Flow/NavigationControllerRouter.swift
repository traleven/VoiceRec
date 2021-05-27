//
//  NavigationControllerRouter.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

@objc class NavigationControllerRouter : NSObject {

	private unowned var navigationController: UINavigationController!
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


	@objc func pop(animated: Bool) {
		if let viewController = navigationController.topViewController {
			willDismiss(viewController)
		}
		navigationController.popViewController(animated: animated)
	}


	@objc func present(_ viewController: UIViewController, onDismiss: (() -> Void)?) {
		dismissHandlers[viewController] = onDismiss
		navigationController.present(viewController, animated: true)
	}


	@objc func dismiss(animated: Bool, completion: (() -> Void)?) {
		if let viewController = navigationController.presentedViewController {
			willDismiss(viewController)
		}
		navigationController.dismiss(animated: animated, completion: completion)
	}


	@objc func willDismiss(_ viewController: UIViewController) {
		let handler = dismissHandlers[viewController]
		handler??()
		dismissHandlers.removeValue(forKey: viewController)
	}
}
