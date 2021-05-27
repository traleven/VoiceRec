//
//  KitchenTabViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 26.05.21.
//

import UIKit

class KitchenTabBarController: UITabBarController {

	override func viewDidAppear(_ animated: Bool) {
		let selector = #selector(handleTabChange(_:))
		NotificationCenter.default.addObserver(self, selector: selector, name: .selectTab, object: nil)
	}

	override func viewDidDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: .selectTab, object: nil)
	}

	@objc private func handleTabChange(_ viewController: ViewController?) {
		self.selectedViewController = viewController
	}
}
