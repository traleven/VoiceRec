//
//  PageDataSource.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PageDataSource: UIPageViewController, UIPageViewControllerDataSource {

	var pageControllers : [UIViewController] = []


	override func viewDidLoad() {
		super.viewDidLoad()

		let storyboard = UIStoryboard(name: "Noodles", bundle: nil)
		pageControllers = [
			storyboard.instantiateViewController(withIdentifier: "themes_list"),
			storyboard.instantiateViewController(withIdentifier: "lessons_list"),
			storyboard.instantiateViewController(withIdentifier: "phrases_list"),
		]

		self.dataSource = nil
		self.setViewControllers([self.pageControllers[0]], direction: .forward, animated: true, completion: { (Bool) in
			//noop
		})

		NotificationCenter.default.addObserver(forName: .pageUpdate, object: nil, queue: OperationQueue.main) { (Notification) in
		}
	}


	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

		let idx = pageControllers.firstIndex(of: viewController) ?? 0
		return idx > 0 ? pageControllers[idx - 1] : nil
	}


	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

		let idx = pageControllers.firstIndex(of: viewController) ?? pageControllers.count - 1
		return idx < pageControllers.count - 1 ? pageControllers[idx + 1] : nil
	}


	func getPageIndex(_ pageViewController : UIPageViewController) -> Int {

		return pageControllers.firstIndex(of: pageViewController.viewControllers![0]) ?? 0
	}


	func setPage(with index : Int, to pageViewController : UIPageViewController) {

		let current = getPageIndex(pageViewController)
		pageViewController.setViewControllers([pageControllers[index]], direction: current > index ? .reverse : .forward, animated: true) { (Bool) in
			// noop
		}
	}
}
