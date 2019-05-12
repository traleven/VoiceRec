//
//  TabViewController.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 11.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class TabViewController : UITabBarController, UITabBarControllerDelegate {

	@IBOutlet var menuConstraint : NSLayoutConstraint?
	@IBOutlet var menuContainer : UIView?
	@IBOutlet var viewContainer : UIView?


	override func viewDidLoad() {

		NotificationCenter.default.addObserver(forName: .swapRoom, object: nil, queue: OperationQueue.main) { (Notification) in
			self.swapRoom()
		}
	}


	@IBAction func swapRoom() {

		let controllerIndex = (selectedIndex + 1) % (self.viewControllers?.count ?? 1)
		let fromView = self.selectedViewController!.view!;
		let toView = self.viewControllers![controllerIndex].view!;

		UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft]) { (_ finished : Bool) in
			if (finished) {
				self.selectedIndex = controllerIndex;
			}
		}
	}
}
