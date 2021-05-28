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
	typealias ApplyHandle = (String) -> Void

	private var flowDelegate: InboxTextEditViewFlowDelegate!
	private var content: String
	private var onApply: ApplyHandle?

	private var returnDelegate: ReturnKeyTextFieldDelegate?

	@IBOutlet var textField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		textField.delegate = returnDelegate
	}


	override func viewWillAppear(_ animated: Bool) {
		textField.text = content

		super.viewWillAppear(animated)
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		textField.becomeFirstResponder()
	}


	override func willMove(toParent parent: UIViewController?) {
		if (parent == nil) {
			flowDelegate.willDismiss(self)
		}
	}


	required init?(coder: NSCoder) {
		fatalError()
	}


	init?(coder: NSCoder, flow: InboxTextEditViewFlowDelegate, content: String?, applyHandle: ApplyHandle?) {
		self.flowDelegate = flow
		self.content = content ?? ""
		self.onApply = applyHandle
		super.init(coder: coder)

		self.returnDelegate = ReturnKeyTextFieldDelegate(keyboardReturn(_:))
	}


	private func keyboardReturn(_ content: String?) -> Bool {
		guard self.textField.text != nil && !self.textField.text!.isEmpty else {
			return false
		}
		self.confirm()
		return true
	}


	@IBAction func confirm() {
		content = textField.text ?? ""
		guard !content.isEmpty else { return }
		onApply?(content)
		flowDelegate.dismiss()
	}


	@IBAction func cancel() {
		flowDelegate.dismiss()
	}
}

class ReturnKeyTextFieldDelegate : NSObject, UITextFieldDelegate {
	private var handleReturnKey: (String?) -> Bool

	init(_ handler: @escaping (String?) -> Bool) {
		self.handleReturnKey = handler
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if handleReturnKey(textField.text) {
			textField.resignFirstResponder()
			return true
		}
		return false
	}
}

