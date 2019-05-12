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
}
