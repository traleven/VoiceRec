//
//  Bowl.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// A mix of `Noodle`s in a specific `Broth` with a specific `Spices`
/// that is used for the language learning session
class Bowl : NSObject {

	var noodles : [Doughball]!
	var broth : Broth!
	var spice : Spices!

	init (_ recipe : Recipe) {
	}


	func eat(withChopsticks : AudioPlayer, andSpoon : AudioPlayer) -> Slurp {

		return Slurp()
	}


	func pack() {
	}
}

class Slurp : NSObject {
}
