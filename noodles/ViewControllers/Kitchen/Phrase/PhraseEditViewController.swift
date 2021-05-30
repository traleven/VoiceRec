//
//  PhraseEditViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

protocol PhraseEditViewFlowDelegate : Director {
	typealias ModelRefreshHandle = (Model.Phrase) -> Void

	func openOptionsMenu(_ phrase: Model.Phrase, language: String, _ refresh: @escaping ModelRefreshHandle)
}

protocol PhraseEditViewControlDelegate : PhraseEditViewFlowDelegate {
	typealias RefreshHandle = () -> Void

	func startRecording(to parent: URL, for language: String, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?)
	func stopRecording(_ refreshHandle: RefreshHandle?)
	func startPlaying(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?)
	func stopPlaying(_ url: URL, _ refreshHandle: RefreshHandle)
}

class PhraseEditViewController: UIViewController {
	typealias ApplyHandle = (Model.Phrase?) -> Void

	private var flowDelegate: PhraseEditViewControlDelegate
	private var content: Model.Phrase
	private var onApply: ApplyHandle?

	private var textDelegates: [Any] = []

	@IBOutlet var baseBlock: UIView!
	@IBOutlet var baseFlag: UIImageView!
	@IBOutlet var baseText: UITextField!
	@IBOutlet var baseAvatar: UIButton!
	@IBOutlet var baseDuration: UILabel!
	@IBOutlet var baseSearch: UIButton!
	@IBOutlet var baseMenu: UIButton!
	@IBOutlet var basePlayButton: UIButton!
	@IBOutlet var baseRecordButton: UIButton!

	@IBOutlet var targetBlock: UIView!
	@IBOutlet var targetFlag: UIImageView!
	@IBOutlet var targetText: UITextField!
	@IBOutlet var targetAvatar: UIButton!
	@IBOutlet var targetDuration: UILabel!
	@IBOutlet var targetSearch: UIButton!
	@IBOutlet var targetMenu: UIButton!
	@IBOutlet var targetPlayButton: UIButton!
	@IBOutlet var targetRecordButton: UIButton!

	@IBOutlet var notesBlock: UIView!
	@IBOutlet var notesText: UITextView!
	@IBOutlet var notesPlaceholder: UIView!

	@IBOutlet var keyboardStubBlock: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		let baseTextDelegate = ReturnKeyTextFieldDelegate(onBeginEdit: {
			self.targetBlock.isHidden = true
			self.notesBlock.isHidden = true
			self.keyboardStubBlock.isHidden = false
		}, onEndEdit: {
			self.targetBlock.isHidden = false
			self.notesBlock.isHidden = false
			self.keyboardStubBlock.isHidden = true
		}, onReturnKey: true)

		let targetTextDelegate = ReturnKeyTextFieldDelegate(onBeginEdit: {
			self.baseBlock.isHidden = true
			self.notesBlock.isHidden = true
			self.keyboardStubBlock.isHidden = false
		}, onEndEdit: {
			self.baseBlock.isHidden = false
			self.notesBlock.isHidden = false
			self.keyboardStubBlock.isHidden = true
		}, onReturnKey: true)

		let notesTextDelegate = ReturnKeyTextViewDelegate(onBeginEdit: {
			self.baseBlock.isHidden = true
			self.targetBlock.isHidden = true
			self.keyboardStubBlock.isHidden = false
			self.notesPlaceholder.isHidden = true
		}, onEndEdit: {
			self.baseBlock.isHidden = false
			self.targetBlock.isHidden = false
			self.keyboardStubBlock.isHidden = true
			self.notesPlaceholder.isHidden = !self.notesText.text.isEmpty
		})

		baseText.delegate = baseTextDelegate
		targetText.delegate = targetTextDelegate
		notesText.delegate = notesTextDelegate

		textDelegates.append(contentsOf: [baseTextDelegate, targetTextDelegate, notesTextDelegate])
	}


	override func viewWillAppear(_ animated: Bool) {
		refresh()

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(onAppMoveToBackground), name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillAppear(animated)
	}


	@objc private func onAppMoveToBackground() {
		updateContent()
		if (!content.baseText.isEmpty || !content.targetText.isEmpty) {
			save()
		}
	}


	override func viewWillDisappear(_ animated: Bool) {
		onAppMoveToBackground()
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)

		super.viewWillDisappear(animated)
	}


	private func refresh(_ phrase: Model.Phrase) {
		content = phrase
		refresh()
	}


	private func refresh() {
		
		baseText.text = content.baseText
		let hasBaseAudio = content.baseAudio != nil
		baseRecordButton.isHidden = hasBaseAudio
		basePlayButton.isHidden = !baseRecordButton.isHidden
		baseSearch.isHidden = hasBaseAudio
		baseMenu.isHidden = !baseSearch.isHidden
		baseDuration.isHidden = true

		targetText.text = content.targetText
		let hasTargetAudio = content.targetAudio != nil
		targetRecordButton.isHidden = hasTargetAudio
		targetPlayButton.isHidden = !targetRecordButton.isHidden
		targetSearch.isHidden = hasTargetAudio
		targetMenu.isHidden = !targetSearch.isHidden
		targetDuration.isHidden = true

		notesText.text = content.comment
		notesPlaceholder.isHidden = !self.notesText.text.isEmpty

		keyboardStubBlock.isHidden = true
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
	}


	required init?(coder: NSCoder) {
		fatalError()
	}


	init?(coder: NSCoder, flow: PhraseEditViewControlDelegate, content: Model.Phrase, applyHandle: ApplyHandle?) {
		self.flowDelegate = flow
		self.content = content
		self.onApply = applyHandle
		super.init(coder: coder)
	}


	private func updateContent() {
		content.baseText = baseText.text ?? ""
		content.targetText = targetText.text ?? ""
		content.comment = notesText.text
	}


	@IBAction @objc func save() {

		updateContent()
		notesText.resignFirstResponder()
		onApply?(content)
	}


	@IBAction func startRecording(_ sender: UIView?) {
		let isBaseLanguage = sender == baseRecordButton
		let language = isBaseLanguage ? Settings.language.base : Settings.language.target
		let durationLabel: UILabel! = isBaseLanguage ? baseDuration : targetDuration

		durationLabel.isHidden = false
		flowDelegate.startRecording(to: content.id, for: language, progress: { (duration: TimeInterval) in
			durationLabel.text = duration.toMinutesTimeString()
		}, finish: { (result: URL?) in
			if result != nil {
				self.content.setAudio(result, for: language)
			}
			durationLabel.isHidden = true
			self.save()
			self.refresh()
		})
	}


	@IBAction func stopRecording(_ sender: UIView?) {
		flowDelegate.stopRecording(nil)
	}


	@IBAction func startPlaying(_ sender: UIControl?) {
		let isBaseLanguage = sender == basePlayButton
		let language = isBaseLanguage ? Settings.language.base : Settings.language.target
		let durationLabel: UILabel! = isBaseLanguage ? baseDuration : targetDuration

		guard let audioUrl = content.audio(language) else {
			return
		}

		if sender != nil && sender!.isSelected {
			flowDelegate.stopPlaying(audioUrl) {
				sender?.isSelected = false
				self.refresh()
			}
			return
		}

		durationLabel.isHidden = false
		sender?.isSelected = true
		flowDelegate.startPlaying(audioUrl, progress: { (progress: TimeInterval, total: TimeInterval) in
			durationLabel.text = (total - progress).toMinutesTimeString()
		}, finish: { (result: Bool) in
			durationLabel.isHidden = true
			sender?.isSelected = false
			self.refresh()
		})
	}


	@IBAction func openOptionMenu(_ sender: UIView?) {
		let isBaseLanguage = sender == baseMenu
		let language = isBaseLanguage ? Settings.language.base : Settings.language.target

		self.updateContent()
		flowDelegate.openOptionsMenu(content, language: language, refresh(_:))
	}
}
