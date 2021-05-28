//
//  LessonsDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class LessonsDirector: DefaultDirector {
}

extension LessonsDirector : LessonsListViewFlowDelegate {

	func openInbox() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Inbox"])
		NotificationCenter.default.post(notification)
	}

	func openPhrases() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Phrases"])
		NotificationCenter.default.post(notification)
	}
}
