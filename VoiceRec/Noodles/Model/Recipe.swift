//
//  Recipe.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation
import CoreData

/// A conteiner of all the required ingridients used
/// to cook a `Bowl` of `Noodle`s
@objc(Recipe)
class Recipe : PersistentObject {

	var noodle : [WeakLink<Noodle>]!
	var broth : WeakLink<Broth>!
	var spice : WeakLink<Spices>!
}
