//
//  ReturnKeyTextFieldDelegate.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 29.05.21.
//

import UIKit

class ReturnKeyTextFieldDelegate : NSObject, UITextFieldDelegate {
	private var handleReturnKey: ((String?) -> Bool)? = nil
	private var handleBeginEdit: (() -> Void)? = nil
	private var handleEndEdit: (() -> Void)? = nil

	init(_ onReturnKey: @escaping (String?) -> Bool) {
		self.handleReturnKey = onReturnKey
	}

	init(onBeginEdit: @escaping () -> Void, onEndEdit: @escaping () -> Void) {
		handleBeginEdit = onBeginEdit
		handleEndEdit = onEndEdit
	}

	init(onBeginEdit: @escaping () -> Void, onEndEdit: @escaping () -> Void, onReturnKey: Bool) {
		handleBeginEdit = onBeginEdit
		handleEndEdit = onEndEdit
		handleReturnKey = { (_: String?) -> Bool in onReturnKey }
	}

	init(onBeginEdit: @escaping () -> Void, onEndEdit: @escaping () -> Void, _ onReturnKey: @escaping (String?) -> Bool) {
		handleBeginEdit = onBeginEdit
		handleEndEdit = onEndEdit
		handleReturnKey = onReturnKey
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		guard let handleReturnKey = handleReturnKey else { return false }

		if handleReturnKey(textField.text) {
			textField.resignFirstResponder()
			return true
		}
		return false
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		handleBeginEdit?()
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		handleEndEdit?()
	}
}

class ReturnKeyTextViewDelegate : NSObject, UITextViewDelegate {
	private var handleBeginEdit: (() -> Void)? = nil
	private var handleEndEdit: (() -> Void)? = nil

	init(onBeginEdit: @escaping () -> Void, onEndEdit: @escaping () -> Void) {
		handleBeginEdit = onBeginEdit
		handleEndEdit = onEndEdit
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		handleBeginEdit?()
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		handleEndEdit?()
	}
}
