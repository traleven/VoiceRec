//
//  UIUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit

extension UIButton {

	func setLanguageFlag(for user: Model.User) {

		let preferBase = Settings.language.preferBase
		setTitle(user.base.flag.rawValue, for: .normal)
		setTitle(user.target.flag.rawValue, for: .selected)
		setTitle(preferBase ? user.base.flag.rawValue : user.target.flag.rawValue, for: .highlighted)
		Self.animate(withDuration: 0.1, animations: {
			self.isSelected = !preferBase
		})
	}
}
