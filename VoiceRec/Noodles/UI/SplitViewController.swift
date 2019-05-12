//
//  SplitViewController.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 10.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {


	@IBOutlet var menuConstraint : NSLayoutConstraint?
	@IBOutlet var menuContainer : UIView?
	@IBOutlet var viewContainer : UIView?
	@IBOutlet var outside : UIControl?


	override func viewDidLoad() {

		NotificationCenter.default.addObserver(forName: .openMenu, object: nil, queue: OperationQueue.main) { (Notification) in
			self.showMenu()
		}
		NotificationCenter.default.addObserver(forName: .closeMenu, object: nil, queue: OperationQueue.main) { (Notification) in
			self.hideMenu()
		}
	}


	@IBAction func toggleMenu() {

		if (menuConstraint?.constant ?? 0) < 0.0 {
			self.showMenu()
		} else {
			self.hideMenu()
		}
	}


	@IBAction func showMenu() {

		menuConstraint?.constant = 0
		viewContainer?.isUserInteractionEnabled = false
		outside?.isUserInteractionEnabled = true
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}


	@IBAction func hideMenu() {

		menuConstraint?.constant = -240
		viewContainer?.isUserInteractionEnabled = true
		outside?.isUserInteractionEnabled = false
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
}
