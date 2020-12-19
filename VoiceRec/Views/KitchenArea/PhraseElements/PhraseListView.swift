//
//  PhraseListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct PhraseListView: View {
	@ObservedObject var viewModel: ViewModel

	var body: some View {
		VStack() {
			List(self.viewModel.children, id: \.id) {(phrase) in
				ZStack() {
					NavigationLink(
						destination: PhraseEditView(phrase, {
							self.viewModel.selectionIdx = nil
						}),
						tag: phrase.id,
						selection: self.$viewModel.selectionIdx) {
						EmptyView()
					}
					PhraseEntry(phrase: phrase)
				}
				.contentShape(Rectangle())
			}
			.navigationBarHidden(true)
			.navigationBarBackButtonHidden(true)
		}
    }
}

extension PhraseListView {
	final class ViewModel: ObservableObject, Defaultable {
		var root: Model.Fridge<Model.Phrase>
		@Published var selectionIdx: URL? = nil

		private var _children : [Model.Phrase]?
		var children : [Model.Phrase] {
			if _children == nil {
				_children = self.root.fetch()
			}
			return _children!
		}

		init() {
			self.root = Model.Fridge(FileUtils.getDirectory(.phrases))
		}

		init(path: URL) {
			self.root = Model.Fridge(path)
		}

		func refresh() {
			self._children = nil
			self.objectWillChange.send()
		}

		func listenUrl() -> Any? {
			return NotificationCenter.default.publisher(for: .NoodlesFileChanged).sink { [weak self](notification) in
				if let url = notification.object as? URL {
					if url == self?.root.root {
						self?.refresh()
					}
				}
			}
		}
	}
}

extension PhraseListView {
	init() {
		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
			self.viewModel = viewModel
		} else {
			self.viewModel = ViewModel()
			ViewModelRegistry.register(self.viewModel)
		}
	}

	init(_ path: URL) {
		self.viewModel = ViewModel(path: path)
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct PhraseListView_Previews: PreviewProvider {
    static var previews: some View {
		PhraseListView(FileUtils.getDefaultsDirectory(.phrases))
    }
}
