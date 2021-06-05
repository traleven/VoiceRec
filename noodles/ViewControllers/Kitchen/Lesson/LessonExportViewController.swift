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

	func selectRepetitionPattern(_ lesson: Model.Recipe, _ refresh: ((Model.Recipe) -> Void)?)
	func updateLivePreviewSettings(_ lesson: Model.Recipe)

	func startLivePreview(_ lesson: @escaping () -> Model.Recipe)
	func stopLivePreview()
	func save(_ lesson: Model.Recipe)
}

class LessonExportViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.Recipe) -> Void

	private var flowDelegate: LessonExportViewControlDelegate!
	private var onApply: ApplyHandle?

	private var lesson: Model.Recipe

	@IBOutlet var nameField: UITextField!

	@IBOutlet var phraseCount: UILabel?
	@IBOutlet var durationLabel: UILabel?

	@IBOutlet var languageButton: UIButton?

	@IBOutlet var phraseRepetionLabel: UIButton!
	@IBOutlet var randomOrderToggle: UISwitch!
	@IBOutlet var insideTimeSpacing: UISlider!
	@IBOutlet var outsideTimeSpacing: UISlider!
	@IBOutlet var phraseVolume: UISlider!
	@IBOutlet var musicVolume: UISlider!


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
		flowDelegate.stopLivePreview()
		updateData()
		flowDelegate.save(lesson)
		super.viewWillDisappearOrMinimize()
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		onApply?(lesson)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init?(coder: NSCoder, flow: LessonExportViewControlDelegate, lesson: Model.Recipe, confirm: ((Model.Recipe) -> Void)?) {

		self.flowDelegate = flow
		self.lesson = lesson
		self.onApply = confirm
		super.init(coder: coder)
	}


	private func refresh() {

		nameField.text = lesson.name
		phraseCount?.text = "\(lesson.phraseCount)"
		durationLabel?.text = "00:00"
		languageButton?.isSelected = !Settings.language.preferBase

		phraseRepetionLabel.setTitle(lesson.shapeString, for: .normal)
		randomOrderToggle.isOn = lesson.spices.randomize
		insideTimeSpacing.value = lesson.spices.delayWithin
		outsideTimeSpacing.value = lesson.spices.delayBetween
		phraseVolume.value = lesson.spices.voiceVolume
		musicVolume.value = lesson.spices.musicVolume
	}


	private func refresh(_ lesson: Model.Recipe) {

		self.lesson = lesson
		refresh()
	}


	private func updateData() {

		let spices = Spices(
			musicVolume: musicVolume.value,
			voiceVolume: phraseVolume.value,
			delayBetween: outsideTimeSpacing.value,
			delayWithin: insideTimeSpacing.value,
			randomize: randomOrderToggle.isOn
		)
		let shape = Shape(dna: phraseRepetionLabel.title(for: .normal) ?? Settings.phrase.defaultShape.dna)
		lesson.spices = spices
		lesson.shape = shape
	}


	@IBAction func toggleLivePreview(_ sender: UIControl) {

		if sender.isSelected {
			flowDelegate.stopLivePreview()
			sender.isSelected = false
		} else {
			sender.isSelected = true
			flowDelegate.startLivePreview({ self.lesson })
		}
	}


	@IBAction func spiceschanged() {

		updateData()
		flowDelegate.updateLivePreviewSettings(lesson)
	}


	@IBAction func toggleLanguage(_ sender: UIControl) {

		Settings.language.preferBase.toggle()
		refresh()
	}


	@IBAction func selectPattern(_ sender: UIControl) {

		flowDelegate.selectRepetitionPattern(lesson, refresh(_:))
	}


	@IBAction func goToPhrasesPage(_ sender: UIControl) {

		flowDelegate.openPhrasesPage(lesson)
	}

	@IBAction func goToMusicPage(_ sender: UIControl) {

		flowDelegate.openMusicPage(lesson)
	}
}
