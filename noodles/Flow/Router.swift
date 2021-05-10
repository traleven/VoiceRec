//
//  Router.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

@objc protocol Router {
	@objc func push(_ viewController: UIViewController, onDismiss: (() -> Void)?)
	@objc func showModal(_ viewController: UIViewController, onDismiss: (() -> Void)?)
	@objc func willDismiss(_ viewController: UIViewController)
}
