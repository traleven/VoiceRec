//
//  PhraseEditViewController.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

protocol PhraseEditViewFlowDelegate : Director {
}

class PhraseEditViewController: UIViewController {
	typealias ApplyHandle = (Model.Phrase?) -> Void

	private var flowDelegate: PhraseEditViewFlowDelegate
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

		super.viewWillAppear(animated)
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
		let hasTargetAudio = content.baseAudio != nil
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


	init?(coder: NSCoder, flow: PhraseEditViewFlowDelegate, content: Model.Phrase, applyHandle: ApplyHandle?) {
		self.flowDelegate = flow
		self.content = content
		self.onApply = applyHandle
		super.init(coder: coder)
	}


	@IBAction @objc func save() {

		content.baseText = baseText.text ?? ""
		content.targetText = targetText.text ?? ""
		content.comment = notesText.text
		notesText.resignFirstResponder()
		onApply?(content)
	}
}
