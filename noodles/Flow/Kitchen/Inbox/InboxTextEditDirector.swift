//
//  InboxTextEditDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import UIKit

class InboxTextEditDirector: DefaultDirector {
	typealias ApplyHandle = (String) -> Void

	func makeViewController(content: String?, applyHandle: ApplyHandle?) -> UIViewController {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "inbox.textedit", creator: { (coder: NSCoder) -> InboxTextEditViewController? in
			return InboxTextEditViewController(coder: coder, flow: self, content: content, applyHandle: applyHandle)
		})
		return viewController
	}
}

extension InboxTextEditDirector : InboxTextEditViewFlowDelegate {
}
