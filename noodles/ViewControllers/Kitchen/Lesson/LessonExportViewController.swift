//
//  LessonExportViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonExportViewFlowDelegate: Director {
}

class LessonExportViewController: NoodlesViewController {

	private var flowDelegate: LessonExportViewFlowDelegate!

	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}
}
