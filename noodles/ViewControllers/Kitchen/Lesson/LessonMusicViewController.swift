//
//  LessonMusicViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonMusicViewFlowDelegate: Director {
}

class LessonMusicViewController: NoodlesViewController {

	private var flowDelegate: LessonMusicViewFlowDelegate!

	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}
}
