//
//  LessonListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 22.06.20.
//

import SwiftUI

struct LessonListView: View {
	@ObservedObject var viewModel: ViewModel
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		VStack() {
			List(self.viewModel.children, id: \.id) {(lesson) in
				ZStack() {
					NavigationLink(
						destination: LessonEditView(lesson.id, deselect: nil),
						tag: lesson.id,
						selection: self.$viewModel.selectionIdx
					) {
						EmptyView()
					}
					LessonEntry(lesson: lesson)
				}
				.contentShape(Rectangle())
			}
			.navigationBarTitle("")
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(
				leading: Button(action: {
					withAnimation { () -> Void in
						self.viewModel.deselector.deselect()
						self.presentationMode.wrappedValue.dismiss()
					}
				}) {
					Text("< Back")
				},
				center: Text(self.viewModel.name ?? ""),
				displayMode: .inline
			)
		}
    }
}

extension LessonListView {
	final class ViewModel: ObservableObject {
		var root: Model.Fridge<Model.Recipe>
		var deselector: Deselector
		@Published var name: String?
		@Published var selectionIdx: URL? = nil

		private var _children : [Model.Recipe]?
		var children : [Model.Recipe] {
			if _children == nil {
				_children = self.root.fetch()
			}
			return _children!
		}

		init() {
			self.root = Model.Fridge(FileUtils.getDirectory(.phrases))
			self.name = nil
			self.deselector = Deselector({})
		}

		init(path: URL, name: String?, deselect: @escaping () -> Void) {
			self.root = Model.Fridge(path)
			self.name = name
			self.deselector = Deselector(deselect)
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

extension LessonListView {
	init() {
		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
			self.viewModel = viewModel
		} else {
			self.viewModel = ViewModel()
			ViewModelRegistry.register(self.viewModel)
		}
	}

	init(_ path: URL) {
		self.init(path, name: nil, deselect: {})
	}

	init(_ path: URL, name: String?, deselect: @escaping () -> Void) {
		self.viewModel = ViewModel(path: path, name: name, deselect: deselect)
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct LessonListView_Previews: PreviewProvider {
    static var previews: some View {
		LessonListView(FileUtils.getDefaultsDirectory(.lessons))
    }
}
