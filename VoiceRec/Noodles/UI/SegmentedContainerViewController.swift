//
//  SegmentedContainerViewController.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class SegmentedContainerViewController : UIViewController {

	@IBOutlet var segmentedControl : UISegmentedControl!
	var pageViewController : PageDataSource!

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if (segue.destination is PageDataSource) {
			pageViewController = segue.destination as? PageDataSource
		}
	}


	@IBAction func changePage(_ sender : UISegmentedControl) {

		pageViewController.setPage(with: sender.selectedSegmentIndex, to: pageViewController)
	}
}
