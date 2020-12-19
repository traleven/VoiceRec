//
//  LessonEditView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import SwiftUIX

struct LessonEditView: View {
	@ObservedObject var viewModel: ViewModel
	@Environment(\.presentationMode) var presentationMode

    var body: some View {
		VStack() {
			TextField("Recipe name", text: self.$viewModel.recipe.name)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.multilineTextAlignment(.center)
			Divider()
			Form {
				ForEach(0..<self.viewModel.recipe.phraseCount) { i in
					PhraseEntry(phrase: Model.Phrase(id: self.viewModel.recipe[i]))
				}
			}
			Divider()
			Text("All phrases")
			Form() {
				PhraseListView(FileUtils.getDefaultsDirectory(.phrases))
			}
			Spacer()
		}
		.keyboardType(.default)
		.navigationBarTitle("", displayMode: .inline)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading:
			Button(action: {
				withAnimation { () -> Void in
					self.viewModel.deselect?.deselect()
					presentationMode.wrappedValue.dismiss()
				}
			}) {
				Text("< Back")
			},
			trailing: Button(action: {
				self.viewModel.save()
			}) {
				Text("Save")
			}
		)
    }

	private func makeNameBinding(_ lesson: Recipe) -> Binding<String> {
		return .init(
			get: { return lesson.name },
			set: { lesson.name = $0 }
		)
	}

	private func makeNotesBinding(_ phrase: Phrase) -> Binding<String> {
		return .init(
			get: { return phrase.comment },
			set: { phrase.comment = $0 }
		)
	}
}

extension LessonEditView {
	final class ViewModel: ObservableObject {
		@Published var recipe: Model.Recipe
		var deselect: Deselector?

		init(_ path: URL, deselect: Deselector?) {
			self.recipe = Model.Recipe(id: path)
			self.deselect = deselect
		}

		func save() {
			self.recipe.save()
		}
	}
}

extension LessonEditView {
	init(_ path: URL) {
		self.init(path, deselect: {})
	}

	init(_ path: URL, deselect: (() -> Void)?) {
		let deselector = deselect == nil ? nil : Deselector(deselect!)
		self.viewModel = ViewModel(path, deselect: deselector)
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct LessonEditView_Previews: PreviewProvider {
    static var previews: some View {
		LessonEditView(Model.Fridge<Model.Recipe>(FileUtils.getDefaultsDirectory(.lessons)).fetch()[0].id,
			deselect: nil
		)
    }
}
