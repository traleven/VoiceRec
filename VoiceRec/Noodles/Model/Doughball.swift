//
//  Doughball.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Annotated and translated phrase that can be used to produce `Noodle`
@objc(Doughball)
class Doughball : PersistentObject {

	var audioFiles : Dictionary<String, URL> = [:]
	var texts : Dictionary<String, String> = [:]
	var salt : String = ""


	class func fetch() -> [Doughball] {

		let a = Doughball()
		a.texts["English"] = "A lot of people think I'm from the Middle East"
		let b = Doughball()
		b.texts["English"] = "Altruistic"
		let c = Doughball()
		c.texts["English"] = "At the end of the day, I just want to say that I care about you"
		let d = Doughball()
		d.texts["English"] = "Axis of power"
		let e = Doughball()
		e.texts["English"] = "Can I have a window seat?"
		
		return [a, b, c, d, e]
	}
}
