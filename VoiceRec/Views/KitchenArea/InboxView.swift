//
//  InboxView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct InboxView: View {
	var recorder: AudioRecorder = AudioRecorder()
	@ObservedObject var viewModel : ViewModel

    var body: some View {
		NavigationView() {
			InboxListView(self.viewModel.listViewModel)
				.border(Color.gray, width: 0.5)
				.navigationBarItems(leading:
					Button(action: {
					}) {
						Image(systemName: "line.horizontal.3")
							.font(.title)
					}
					.foregroundColor(.black)
				)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

extension InboxView {
	final class ViewModel: ObservableObject, Defaultable {
		@Published var path: URL = FileUtils.getDirectory(.inbox)
		var listViewModel: InboxListView.ViewModel = InboxListView.ViewModel(path: FileUtils.getDirectory(.inbox))

		init() {}

		init(path: URL) {
			self.path = path
			self.listViewModel = InboxListView.ViewModel(path: path)
		}
	}
}

extension InboxView {
	init() {
		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
			self.viewModel = viewModel
		} else {
			self.viewModel = ViewModel()
			ViewModelRegistry.register(self.viewModel)
		}
	}

	init(_ model: ViewModel) {
		self.viewModel = model
	}
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
		InboxView()
    }
}
