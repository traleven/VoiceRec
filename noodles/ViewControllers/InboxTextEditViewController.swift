//
//  InboxTextEditViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 11.05.21.
//

import UIKit

protocol InboxTextEditViewFlowDelegate : Director {
}

class InboxTextEditViewController: UIViewController {

	private var flowDelegate: InboxTextEditViewFlowDelegate!
	private var url: URL
	private var current: Model.Egg?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


	override func viewWillAppear(_ animated: Bool) {
		current = Model.Egg(id: url)

		super.viewWillAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
	}


	required init?(coder: NSCoder) {
		fatalError()
	}


	init?(coder: NSCoder, flow: InboxTextEditViewFlowDelegate, id: URL) {
		self.flowDelegate = flow
		self.url = id
		super.init(coder: coder)
	}


	@IBAction func confirm() {
	}


	@IBAction func cancel() {
	}
}
