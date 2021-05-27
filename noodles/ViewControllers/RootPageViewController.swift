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
				pan.isEnabled = false
			}
			if let tap = recognizer as? UITapGestureRecognizer {
				tap.numberOfTapsRequired = 2
				tap.numberOfTouchesRequired = 1
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
