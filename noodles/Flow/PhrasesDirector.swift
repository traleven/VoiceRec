//
//  PhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class PhrasesDirector: DefaultDirector {
}

extension PhrasesDirector : PhrasesListViewFlowDelegate {

	func openInbox() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Inbox"])
		NotificationCenter.default.post(notification)
	}

	func openLessons() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Lessons"])
		NotificationCenter.default.post(notification)
	}
}
