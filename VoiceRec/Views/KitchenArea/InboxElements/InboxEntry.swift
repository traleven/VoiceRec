//
//  InboxEntry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct InboxEntry: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		HStack() {
			if viewModel.egg.type == .audio {

				Image("speech")
					.scaleEffect(0.5)
				Text(viewModel.egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else if viewModel.egg.type == .text || viewModel.egg.type == .json {

				Image("reorder")
					.scaleEffect(0.5)
				Text(viewModel.egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else if viewModel.egg.type == .directory {

				Image("folder_selected")
					.scaleEffect(0.5)
				Text(viewModel.egg.name)
					.multilineTextAlignment(.leading)
					.padding()

			} else {
				Text(viewModel.egg.name)
					.multilineTextAlignment(.leading)
					.padding()
			}
			Spacer()
		}
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation() {
				self.viewModel.parent.selectionIdx = self.viewModel.egg.id
			}
		}
		.gesture(
			LongPressGesture(minimumDuration: 0.5, maximumDistance: 3).onEnded({ (success: Bool) in
				if success {
					self.previewItem(self.viewModel.egg)
				}
			})
		)
		.sheet(isPresented: self.$viewModel.showDetails) {
			TextPreview(viewModel: self.viewModel)
		}
    }

	func previewItem(_ egg: Model.Egg) {
		switch egg.type {
		case .audio:
			AudioPlayer(egg.id)
				.play(
					onProgress: { (_: TimeInterval, _: TimeInterval) in
				}) { (_: Bool) in
			}
		case .text, .json:
			self.viewModel.showDetails = true
		default:
			do {}
		}
	}

	@GestureState var isLongPress = false // will be true till tap hold

	var plusLongPress: some Gesture {
		LongPressGesture(minimumDuration: 1).sequenced(before:
			  DragGesture(minimumDistance: 0, coordinateSpace:
			  .local)).updating($isLongPress) { value, state, transaction in
				switch value {
					case .second(true, nil):
						state = true
					   // side effect here if needed
					default:
						break
				}
			}
	}
}

extension InboxEntry {
	final class ViewModel: ObservableObject {
		var parent: InboxListView.ViewModel
		var egg: Model.Egg

		@Published var showDetails: Bool = false

		init(parent: InboxListView.ViewModel, egg: Model.Egg) {
			self.parent = parent
			self.egg = egg
		}
	}
}

extension InboxEntry {
	init(parent: InboxListView.ViewModel, egg: Model.Egg) {
//		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
//			self.viewModel = viewModel
//		} else {
			self.viewModel = ViewModel(parent: parent, egg: egg)
//			ViewModelRegistry.register(self.viewModel)
//		}
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct InboxEntry_Previews: PreviewProvider {
	static var parent = InboxListView.ViewModel()
    static var previews: some View {
		Group {
			ForEach(parent.children, id: \.egg.id) {
				InboxEntry(parent: parent, egg: $0.egg)
			}
		}
		.previewLayout(.fixed(width: 480, height: 70))
    }
}
