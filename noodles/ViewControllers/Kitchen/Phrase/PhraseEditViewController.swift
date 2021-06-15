//
//  PhraseEditViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

protocol PhraseEditViewFlowDelegate : Director {
	typealias ModelRefreshHandle = (Model.Phrase) -> Void

	func openOptionsMenu(_ phrase: Model.Phrase, language: Language, _ refresh: @escaping ModelRefreshHandle)
}

protocol PhraseEditViewControlDelegate : PhraseEditViewFlowDelegate {
	typealias RefreshHandle = () -> Void

	func startRecording(to parent: URL, for language: Language, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?)
	func stopRecording(_ refreshHandle: RefreshHandle?)
	func startPlaying(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?)
	func stopPlaying(_ url: URL, _ refreshHandle: RefreshHandle?)
	func stopAllAudio()
}

class PhraseEditViewController: NoodlesViewController {
	typealias ApplyHandle = (Model.Phrase?) -> Void

	private var flowDelegate: PhraseEditViewControlDelegate
	private var content: Model.Phrase
	private var onApply: ApplyHandle?

	private var textDelegates: [AnyObject] = []

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
		}, onEndEdit: { _ in
			self.targetBlock.isHidden = false
			self.notesBlock.isHidden = false
			self.keyboardStubBlock.isHidden = true
		}, onReturnKey: true)

		let targetTextDelegate = ReturnKeyTextFieldDelegate(onBeginEdit: {
			self.baseBlock.isHidden = true
			self.notesBlock.isHidden = true
			self.keyboardStubBlock.isHidden = false
		}, onEndEdit: { _ in
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

		super.viewWillAppear(animated)
	}


	override func viewWillDisappearOrMinimize() {
		updateContent()
		save()
		flowDelegate.stopAllAudio()
		
		super.viewWillDisappearOrMinimize()
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
		super.willMove(toParent: parent)
	}


	private func refresh(_ phrase: Model.Phrase) {
		content = phrase
		refresh()
	}


	private func refreshLabel(durationLabel label: UILabel, for url: URL?) {
		url?.loadAsyncDuration({ [weak label] (duration: TimeInterval) in
			label?.text = duration.toMinutesTimeString()
		})
	}


	private func refresh() {
		
		baseText.text = content.baseText
		let hasBaseAudio = content.baseAudio != nil
		baseRecordButton.isHidden = hasBaseAudio
		basePlayButton.isHidden = !baseRecordButton.isHidden
		baseSearch.isHidden = hasBaseAudio
		baseMenu.isHidden = !baseSearch.isHidden
		baseDuration.isHidden = !hasBaseAudio
		baseDuration.text = ""
		refreshLabel(durationLabel: baseDuration, for: content.baseAudio)

		targetText.text = content.targetText
		let hasTargetAudio = content.targetAudio != nil
		targetRecordButton.isHidden = hasTargetAudio
		targetPlayButton.isHidden = !targetRecordButton.isHidden
		targetSearch.isHidden = hasTargetAudio
		targetMenu.isHidden = !targetSearch.isHidden
		targetDuration.isHidden = !hasTargetAudio
		targetDuration.text = ""
		refreshLabel(durationLabel: targetDuration, for: content.targetAudio)

		notesText.text = content.comment
		notesPlaceholder.isHidden = !self.notesText.text.isEmpty

		keyboardStubBlock.isHidden = true
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


	@IBAction func save() {

		updateContent()
		notesText.resignFirstResponder()
		onApply?(content)
	}


	@IBAction func startRecording(_ sender: UIView?) {
		let isBaseLanguage = sender == baseRecordButton
		let language = isBaseLanguage ? Model.User.Me.base : Model.User.Me.target
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
		let language = isBaseLanguage ? Model.User.Me.base : Model.User.Me.target
		let durationLabel: UILabel! = isBaseLanguage ? baseDuration : targetDuration

		guard let audioUrl = content.audio(language) else {
			return
		}

		if sender != nil && sender!.isSelected {
			flowDelegate.stopPlaying(audioUrl, nil)
			return
		}

		durationLabel.isHidden = false
		sender?.isSelected = true
		flowDelegate.startPlaying(audioUrl, progress: { (progress: TimeInterval, total: TimeInterval) in
			durationLabel.text = (total - progress).toMinutesTimeString()
		}, finish: { _ in
			sender?.isSelected = false
			self.refreshLabel(durationLabel: durationLabel, for: audioUrl)
		})
	}


	@IBAction func openOptionMenu(_ sender: UIView?) {
		let isBaseLanguage = sender == baseMenu
		let language = isBaseLanguage ? Model.User.Me.base : Model.User.Me.target

		self.updateContent()
		flowDelegate.openOptionsMenu(content, language: language, refresh(_:))
	}
}
