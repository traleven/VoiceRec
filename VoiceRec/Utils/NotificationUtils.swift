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
	static let swapRoom = Notification.Name("noodles_swap_room")
}


extension UIViewController {

	@IBAction func openMenu() {

		NotificationCenter.default.post(name: .openMenu, object: self)
	}

	@IBAction func closeMenu() {

		NotificationCenter.default.post(name: .closeMenu, object: self)
	}

	@IBAction func swapRooms() {

		NotificationCenter.default.post(name: .swapRoom, object: self)
	}
}
