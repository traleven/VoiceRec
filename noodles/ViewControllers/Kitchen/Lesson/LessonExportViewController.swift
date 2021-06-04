//
//  LessonExportViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import UIKit

protocol LessonExportViewFlowDelegate: Director {

	func openPhrasesPage(_ lesson: Model.Recipe)
	func openMusicPage(_ lesson: Model.Recipe)
}

protocol LessonExportViewControlDelegate: LessonExportViewFlowDelegate {

	func startLivePreview(_ lesson: Model.Recipe, finish: (() -> Void)?)
	func stopLivePreview(_ lesson: Model.Recipe)
	func stopAllAudio()
}

class LessonExportViewController: NoodlesViewController {

	private var flowDelegate: LessonExportViewControlDelegate!

	private var lesson: Model.Recipe

	@IBOutlet var nameField: UITextField!

	@IBOutlet var phraseCount: UILabel?
	@IBOutlet var durationLabel: UILabel?

	@IBOutlet var languageButton: UIButton?


	override func viewWillAppear(_ animated: Bool) {
		refresh()

		super.viewWillAppear(animated)
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}

	
	override func viewWillDisappearOrMinimize() {
		flowDelegate.stopAllAudio()
		super.viewWillDisappearOrMinimize()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, flow: LessonExportViewControlDelegate, lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) {

		self.flowDelegate = flow
		self.lesson = lesson
		super.init(coder: coder)
	}


	private func refresh() {

		nameField.text = lesson.name
		phraseCount?.text = "\(lesson.phraseCount)"
		durationLabel?.text = "00:00"
		languageButton?.isSelected = !Settings.language.preferBase
	}


	@IBAction func toggleLivePreview(_ sender: UIControl) {

		if sender.isSelected {
			flowDelegate.stopLivePreview(lesson)
		} else {
			sender.isSelected = true
			flowDelegate.startLivePreview(lesson) {
				sender.isSelected = false
			}
		}
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {

		Settings.language.preferBase.toggle()
		refresh()
	}


	@IBAction func goToPhrasesPage(_ sender: UIControl) {

		flowDelegate.openPhrasesPage(lesson)
	}

	@IBAction func goToMusicPage(_ sender: UIControl) {

		flowDelegate.openMusicPage(lesson)
	}
}
