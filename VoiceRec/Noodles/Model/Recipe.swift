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

	var name : String!
	var noodle : [WeakLink<Noodle>]!
	var broth : WeakLink<Broth>!
	var spice : WeakLink<Spices>!


	class func fetch() -> [Recipe] {

		let a = Recipe()
		a.name = "Travel"
		let b = Recipe()
		b.name = "Other"

		return [a, b]
	}
}
