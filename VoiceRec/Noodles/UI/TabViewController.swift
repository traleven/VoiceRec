//
//  TabViewController.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 11.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class TabViewController : UITabBarController, UITabBarControllerDelegate {

	var views : Dictionary<String, Int> = [:]
	@IBInspectable var flipTransition : Bool = true

	override func setValue(_ value: Any?, forUndefinedKey key: String) {
		if (value is Int && key.starts(with: "goto_")) {
			views[key] = (value as! Int)
		} else {
			super.setValue(value, forKey: key)
		}
	}

	override func viewDidLoad() {

		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(forName: .gotoView, object: nil, queue: OperationQueue.main) { (_ notification : Notification) in
			guard let idx = self.views[notification.userInfo!["target"] as! String] else {
				return
			}
			self.transit(to: idx)
		}
	}


	func transit(to index : Int) {

		guard index != self.selectedIndex else {
			return
		}

		let fromView = self.selectedViewController!.view!;
		let toView = self.viewControllers![index].view!;

		UIView.transition(from: fromView, to: toView, duration: 0.5, options: [flipTransition ? .transitionFlipFromLeft : .transitionCurlUp]) { (_ finished : Bool) in
			if (finished) {
				self.selectedIndex = index
			}
		}
	}
}
