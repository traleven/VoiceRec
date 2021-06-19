//
//  Model.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 09.12.20.
//

import Foundation

protocol FileNameResolver {
	func getName(_ source : URL) -> String
}

protocol IdInitializable {
	associatedtype ID
	init(id: Self.ID)
}

protocol Traversable {
	associatedtype ID
	static func getChildren(_ id: Self.ID) -> [Self.ID]
}

protocol Savable {
	func save()
}

struct Model {
//	var eggs	: Model.Fridge<Model.Egg>
//	var broths	: Model.Fridge<Model.Broth>
//	var phrases	: Model.Fridge<Model.Phrase>
//	var recipes	: Model.Fridge<Model.Recipe>
}
