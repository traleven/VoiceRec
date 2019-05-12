//
//  Broth.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import CoreData

/// Background audio (music) used to add a specific "taste"
/// to the `Noodle`s in a `Bowl`
@objc(Broth)
class Broth : PersistentObject {

	var name : String!
	var audioFile : URL!
}
