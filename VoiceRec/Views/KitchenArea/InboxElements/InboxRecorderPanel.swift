//
//  InboxRecorderPanel.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct InboxRecorderPanel: View {
	@ObservedObject var viewModel : ViewModel
	@State var addText: Bool = false
	var path: URL

	var body: some View {
		VStack(alignment: .center) {
			if viewModel.recorder.isRecording {
				Group {
					Text("New egg")
					Text(Int(viewModel.recorder.duration).toTimeString())
						.font(.largeTitle)
						.fixedSize()
						.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
						.allowsTightening(true)
						.minimumScaleFactor(0.7)
						.padding(.bottom)
				}
				.transition(self.timerTransition)
				.animation(.easeOut(duration: 0.3))
			}

			HStack(alignment: .bottom) {
				Spacer()
				AudioRecorderButton(path: self.path)
				Spacer()
			}
		}.padding()
    }

	var timerTransition: AnyTransition {
		get {
			AnyTransition.asymmetric(
				insertion: AnyTransition.move(edge: .bottom).animation(.easeOut).combined(with: AnyTransition.opacity.animation(.easeInOut(duration:0.3))),
				removal: AnyTransition.move(edge: .top).animation(.easeIn(duration:0.3))
			)
		}
	}
}

extension InboxRecorderPanel {
	final class ViewModel: ObservableObject, Defaultable {
		let recorder: AudioRecorder
		var cancellable: Any? = nil

		init() {
			self.recorder = ViewModelRegistry.fetch()!
			cancellable = self.republish(self.recorder)
		}
	}
}

extension InboxRecorderPanel {
	init(path: URL) {
		self.path = path
		if let viewModel : ViewModel = ViewModelRegistry.fetch() {
			self.viewModel = viewModel
		} else {
			self.viewModel = ViewModel()
			ViewModelRegistry.register(self.viewModel)
		}
	}

	init(_ model: ViewModel, path: URL) {
		self.path = path
		self.viewModel = model
	}
}

struct InboxRecorderPanel_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			VStack() {
				Spacer()
				InboxRecorderPanel(path: FileUtils.getDirectory(.inbox))
			}
		}
		.environmentObject(AudioRecorder())
		.previewLayout(.fixed(width: 420, height: 280))
    }
}
