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
	static let refreshMusic = Notification.Name("refresh_music")
	static let appGoesBackground = Notification.Name("background")

	static let openMenu = Notification.Name("noodles_open_menu")
	static let closeMenu = Notification.Name("noodles_close_menu")

	static let gotoView = Notification.Name("goto")
	static let pageUpdate = Notification.Name("noodles_page_update")
}


extension UIViewController {

	@IBAction func openMenu() {

		NotificationCenter.default.post(name: .openMenu, object: self)
	}

	@IBAction func closeMenu() {

		NotificationCenter.default.post(name: .closeMenu, object: self)
	}

	@IBAction func postValueChanged(_ sender : UISegmentedControl) {

		NotificationCenter.default.post(name: .pageUpdate, object: sender)
	}
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
