//
//  Model.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 09.12.20.
//

import SwiftUI

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

struct Model: View {
	var eggs	: Model.Fridge<Model.Egg>
	var broths	: Model.Fridge<Model.Broth>
	var phrases	: Model.Fridge<Model.Phrase>
	var recipes	: Model.Fridge<Model.Recipe>

    var body: some View {
		VStack {
			Text("Hello, World!")
			Divider()
			ForEach(eggs.fetch(), id: \.id) { egg in
				Text(egg.name)
			}
			Divider()
			ForEach(broths.fetch(), id: \.id) { broth in
				Text(broth.name)
			}
			Divider()
			ForEach(phrases.fetch(), id: \.id) { phrase in
				Text(phrase.name)
			}
			Divider()
			ForEach(recipes.fetch(), id: \.id) { recipe in
				Text(recipe.name)
				ForEach(0..<recipe.phraseCount) { idx -> Text in
					let phrase = Model.Phrase(id: recipe[idx])
					return Text(phrase.name)
				}
			}
			Divider()
		}
    }
}

struct Model_Previews: PreviewProvider {
    static var previews: some View {
		Model(
			eggs: Model.Fridge(FileUtils.getDefaultsDirectory(.inbox)),
			broths: Model.Fridge(FileUtils.getDefaultsDirectory(.music)),
			phrases: Model.Fridge(FileUtils.getDefaultsDirectory(.phrases)),
			recipes: Model.Fridge(FileUtils.getDefaultsDirectory(.lessons))
		)
    }
}
