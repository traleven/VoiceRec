//
//  Spices.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

/// Setting required to cook a `Bowl` of `Noodle`s
struct Spices : Codable {
	var musicVolume: Float = 0.5
	var voiceVolume: Float = 0.8
	var delayBetween: Float = 3
	var delayWithin: Float = 1
	var randomize: Bool = true
}
