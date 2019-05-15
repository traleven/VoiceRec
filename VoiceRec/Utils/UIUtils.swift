//
//  UIUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 02.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class UIUtils {

	class func display_alert(at_view_controller: UIViewController, msg_title : String , msg_desc : String ,action_title : String) {

		let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: action_title, style: .default)
		{
			(result : UIAlertAction) -> Void in
			_ = at_view_controller.navigationController?.popViewController(animated: true)
		})
		at_view_controller.present(ac, animated: true)
	}
}


extension UIView {
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if parentResponder is UIViewController {
				return parentResponder as? UIViewController
			}
		}
		return nil
	}
}

extension UIViewController : UITextFieldDelegate {

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension UIViewController : UITextViewDelegate {

	public func textViewDidChange(_ textView: UITextView) {
		
		let fixedWidth = textView.frame.size.width
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
	}
}
