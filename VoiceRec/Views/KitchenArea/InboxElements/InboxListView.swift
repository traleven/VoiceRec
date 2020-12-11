//
//  FileListView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.06.20.
//

import SwiftUI

struct InboxListView: View {
	@ObservedObject var viewModel : ViewModel
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		VStack() {
			List(self.viewModel.children, id: \.egg.id) {(childModel) in
				InboxEntry(parent: self.viewModel, egg: childModel.egg)
					.navigate(isActive: self.makeActivationBinding(childModel)) {
						InboxListView(childModel)
					}
			}
			.overlay(self.addTextButton, alignment: .bottomTrailing)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(
				center: Text(self.viewModel.name),
				trailing: Button(
					action: {
						self.viewModel.confirmDelition.toggle()
					},
					label: {
						Text("Delete").foregroundColor(.red)
					})
					.disabled(self.viewModel.isInbox)
					.opacity(self.viewModel.isInbox ? 0.5 : 1)
					.alert(isPresented: self.$viewModel.confirmDelition, content: {
						let title = "Delete item?"
						let message = "Are you sure you want to delete '\(self.viewModel.name)' and all its subitems?"
						let no : Alert.Button = .cancel()
						let yes : Alert.Button = .destructive(Text("Delete"), action: {
							self.viewModel.deleteSelf()
							self.presentationMode.wrappedValue.dismiss()
						})
						return Alert(title: Text(title), message: Text(message), primaryButton: no, secondaryButton: yes)
					}),
				displayMode: .inline
			)
			.if(!self.viewModel.isInbox) {
				$0.navigationBarItems(
					leading: Button(
						action: {
						   self.viewModel.active = false
						   presentationMode.wrappedValue.dismiss()
					   },
					   label: {
						   Text("< Back")
					   }
				).disabled(self.viewModel.isInbox).deleteDisabled(true))
			}

			InboxRecorderPanel(path: self.viewModel.path)
		}
    }

	func makeActivationBinding(_ viewModel: ViewModel) -> Binding<Bool> {
		return .init(get: { viewModel.active }, set: { viewModel.active = $0 })
	}

	var addTextButton: some View {
		get {
			Button(
				action:{
					withAnimation { () -> Void in
						self.viewModel.addText.toggle()
					}
				}
			) {
				Image(systemName: "plus.circle.fill")
					.font(.largeTitle)
					.padding()
			}
			.sheet(isPresented: self.$viewModel.addText) {
				TextMemoEditor(
					parent: self.viewModel,
					title: "Text note",
					placeholder:"Enter your note here..."
				)
			}

		}
	}
}

extension InboxListView {
	final class ViewModel: ObservableObject, Defaultable {
		var parent: ViewModel? = nil
		var cancellableEggChange: Any? = nil
		var egg: Model.Egg
		private var _children : [ViewModel]?
		var children : [ViewModel] {
			if _children == nil {
				_children = self.egg.children.map({ (_ id: URL) -> ViewModel in
					ViewModel(path: id, parent: self)
				})
			}
			return _children!
		}

		var active: Bool {
			get { (self.parent == nil && self.selectionIdx == nil) || self.parent?.selectionIdx == egg.id }
			set { self.parent?.selectionIdx = newValue ? egg.id : nil }
		}

		var name: String {
			self.egg.name
		}

		var isInbox: Bool {
			self.egg.type == .inbox
		}

		@Published var path: URL
		@Published var selectionIdx: URL? = nil
		@Published var addText: Bool = false
		@Published var confirmDelition = false

		init() {
			let defaultPath = FileUtils.getDirectory(.inbox)
			self.path = defaultPath
			self.egg = Model.Egg(id: defaultPath)
			self.cancellableEggChange = self.listenUrl()
		}

		convenience init(path: URL) {
			self.init(path: path, parent: nil)
		}

		init(path: URL, parent: ViewModel?) {
			self.path = path
			self.parent = parent
			self.egg = Model.Egg(id: path)
			self.cancellableEggChange = self.listenUrl()
		}

		func refresh() {
			self.egg = Model.Egg(id: self.path)
			self._children = nil
			self.objectWillChange.send()
		}

		func listenUrl() -> Any? {
			return NotificationCenter.default.publisher(for: .NoodlesFileChanged).sink { [weak self](notification) in
				if let url = notification.object as? URL {
					if url == self?.path {
						self?.refresh()
					}
				}
			}
		}

		func deleteSelf() {
			let fmg = FileManager.default
			try? fmg.removeItem(at: self.path)
			self.active = false
			self.parent?.refresh()
		}
	}
}

extension InboxListView {
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

struct InboxListView_Previews: PreviewProvider {
    static var previews: some View {
		InboxListView(FileUtils.getDefaultsDirectory(.inbox))
			.previewLayout(.fixed(width: 480, height: 800))
    }
}
