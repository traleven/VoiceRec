//
//  NotificationUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

extension Notification.Name {
	
	static let refreshPhrases = Notification.Name("refresh_phrases")
	static let refreshLessons = Notification.Name("refresh_lessons")
	static let refreshMusic = Notification.Name("refresh_music")
	static let appGoesBackground = Notification.Name("background")

	static let gotoView = Notification.Name("goto")

	static let selectTab = Notification.Name("noodles_select_tab");
}

extension Notification.Name {
	public static let NoodlesFileChanged: Notification.Name = Notification.Name("NoodlesFileChanged")
}

extension UIApplication {
	func hideKeyboard() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}


class ScreenReference : NSObject {

	@IBInspectable var uri : String!

	@IBAction func gotoRoom(_ sender : UIControl) {

		let path = uri.split(separator: "/")
		for component in path {
			NotificationCenter.default.post(name: .gotoView, object: self, userInfo: ["target" : "goto_\(component)"])
		}
	}
}
