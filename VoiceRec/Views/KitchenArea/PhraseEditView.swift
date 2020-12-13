//
//  PhraseEditView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI
import SwiftUIX

struct PhraseEditView: View {
	@ObservedObject var viewModel: ViewModel
	@Environment(\.presentationMode) var presentationMode

    var body: some View {
		Form() {
			Section(header: Text("\(Settings.language.base)")) {
				PhraseLanguagePanel(text: makeTextBinding(self.viewModel, language: Settings.language.base), audio: .constant(self.viewModel.phrase.baseAudio))
			}
			Section(header: Text("\(Settings.language.target)")) {
				PhraseLanguagePanel(text: makeTextBinding(self.viewModel, language: Settings.language.target), audio: .constant(self.viewModel.phrase.targetAudio))
			}
			MultilineTextField("Notes", text: makeNotesBinding(self.viewModel))
		}
		.keyboardType(.default)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden(true)
		.ifKeyboardIsShowing {
			$0.navigationBarItems(
				leading:EmptyView(),
				center: EmptyView(),
				trailing: Button(action: {
					UIApplication.shared.hideKeyboard()
				}) {
					Text("Done")
				},
				displayMode: .inline
			)
		}
		.ifKeyboardIsNotShowing {
			$0.navigationBarItems(
				leading: Button(action: {
					withAnimation { () -> Void in
						self.viewModel.parent.deselect()
						presentationMode.wrappedValue.dismiss()
					}
				}) {
					Text("< Back")
				},
				center: EmptyView(),
				trailing: Button(action: {
					self.viewModel.save()
				}) {
					Text("Save")
				},
				displayMode: .inline
			)
		}
    }

	private func makeTextBinding(_ viewModel: ViewModel, language: String) -> Binding<String> {
		return .init(
			get: { return viewModel.phrase.text(language) },
			set: { viewModel.phrase.setText($0, for: language) }
		)
	}

	private func makeNotesBinding(_ viewModel: ViewModel) -> Binding<String> {
		return .init(
			get: { return viewModel.phrase.comment },
			set: { viewModel.phrase.comment = $0 }
		)
	}
}

extension PhraseEditView {
	final class ViewModel: ObservableObject {
		var phrase: Model.Phrase
		var parent: Deselector

		init(path: URL, deselect: @escaping () -> Void) {
			self.phrase = Model.Phrase(id: path)
			self.parent = Deselector(deselect)
		}

		init(phrase: Model.Phrase, deselect: @escaping () -> Void) {
			self.phrase = phrase
			self.parent = Deselector(deselect)
		}

		func save() {
			phrase.save()
			NotificationCenter.default.post(name: .NoodlesFileChanged, object: phrase.id.deletingLastPathComponent())
		}
	}
}

extension PhraseEditView {
	init(_ path: URL, _ deselect: @escaping () -> Void) {
		self.viewModel = ViewModel(path: path, deselect: deselect)
	}

	init(_ phrase: Model.Phrase, _ deselect: @escaping () -> Void) {
		self.viewModel = ViewModel(phrase: phrase, deselect: deselect)
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct PhraseEditView_Previews: PreviewProvider {
    static var previews: some View {
		let fridge = Model.Fridge<Model.Phrase>(FileUtils.getDefaultsDirectory(.phrases))
		ForEach(fridge.fetch(), id: \.id) { phrase in
			PhraseEditView(phrase.id, {})
		}
    }
}
