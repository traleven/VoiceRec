//
//  RootPageViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 06.05.21.
//

import UIKit

class RootPageViewController : UIPageViewController {

	private var items: [UIViewController] = [
		UIStoryboard(name: "Kitchen", bundle: nil).instantiateInitialViewController()!,
		UIStoryboard(name: "Dining", bundle: nil).instantiateInitialViewController()!,
		UIStoryboard(name: "Service", bundle: nil).instantiateInitialViewController()!,
	   ]

	override func viewDidLoad() {
		super.viewDidLoad()

		dataSource = self
		delegate = self

		for recognizer in self.gestureRecognizers {
			if let pan = recognizer as? UIPanGestureRecognizer {
				pan.isEnabled = true
			}
			if let tap = recognizer as? UITapGestureRecognizer {
				tap.isEnabled = false
			}
		}

		setViewControllers([items.first!], direction: .forward, animated: true, completion: nil)
	}
}

extension RootPageViewController : UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let current = items.firstIndex(of: viewController) else {
			return items[0]
		}
		return items[(current + items.count - 1) % items.count]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let current = items.firstIndex(of: viewController) else {
			return items[0]
		}
		return items[(current + 1) % items.count]
	}

	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return items.count
	}
}

extension RootPageViewController : UIPageViewControllerDelegate {
}

extension RootPageViewController : UIGestureRecognizerDelegate {

	// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

		if let window = touch.window {
			let point = touch.location(in: nil)
			let bounds = window.bounds
			let horizontalEdge = point.x / bounds.width
			return horizontalEdge < 0.1 || 0.9 < horizontalEdge
		}
		return false
	}
}
