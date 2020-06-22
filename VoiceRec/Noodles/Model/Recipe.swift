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
class Recipe : PersistentObject, Codable {

	var name : String!
	var noodle : [WeakLink<Noodle>]!
	var broth : WeakLink<Broth>!
	var spice : WeakLink<Spices>!

	var idx: Int = 0


	class func with(contentOf file: URL) -> Recipe {
		return load(file)
	}

	class func fetchDefault() -> [Recipe] {

		let a = Recipe()
		a.name = "Travel"
		let b = Recipe()
		b.name = "Other"

		return [a, b]
	}


	class func fetch() -> [Recipe] {

		let baseUrl = FileUtils.getDirectory(.lesons)
		return fetch(baseUrl)
	}

	class func fetch(_ path: URL?) -> [Recipe] {
		guard (path != nil) else {
			return fetch()
		}

		guard let files = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {

			return []
		}

		var data : [Recipe] = []
		for url in files.filter({ (url: URL) -> Bool in url.pathExtension == "recipe" }) {

			let recipe = Recipe.with(contentOf: url)
			recipe.idx = data.count
			data.append(recipe)
		}

		return data
	}


	class func make(_ idx: Int, _ name: String, broth: Broth, spice: Spices, noodles: [Noodle]) -> Recipe {
		let a = Recipe()
		a.idx = idx
		a.name = name
		a.broth = .init(broth)
		a.spice = .init(spice)
		a.noodle = noodles.map({ WeakLink.init($0) })
		return a
	}
}
