//
//  Router.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

@objc protocol Router {
	
	@objc func present(_ viewController: UIViewController, onDismiss: (() -> Void)?)
	@objc func dismiss(animated: Bool, completion: (() -> Void)?)
	@objc func push(_ viewController: UIViewController, onDismiss: (() -> Void)?)
	@objc func pop(animated: Bool)

	@objc func willDismiss(_ viewController: UIViewController)
}
