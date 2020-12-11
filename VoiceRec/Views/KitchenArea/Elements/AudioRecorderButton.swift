//
//  AudioRecorderButton.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct AudioRecorderButton: View {
	@ObservedObject var viewModel: ViewModel
	var path: URL

	var body: some View {
		self.viewModel.recorder.isRecording
		? Button(action: {
			self.viewModel.recorder.finishAudioRecording()
		}) {
			ZStack() {

				Image(systemName: "waveform")
					.font(.system(size: 48))
					.overlay(Circle().stroke(lineWidth: 1).scale(2.5))
			}
			.foregroundColor(.red)
			.padding(.bottom)
		}
		: Button(action: {
			if !self.path.pathExtension.isEmpty && FileManager.default.fileExists(atPath: self.path.path) {
				let dir = self.path.deletingPathExtension()
				FileUtils.ensureDirectory(dir)
				do {
					try FileManager.default.moveItem(at: self.path, to: dir.appendingPathComponent(self.path.lastPathComponent))
				} catch {
					fatalError("Failed to convert an item into a package")
				}
			}

			self.viewModel.recorder.start_recording(FileUtils.getNewInboxFile(at:self.path.deletingPathExtension(), withName: "", andExtension: "m4a"), progress: nil) { (success: Bool) in
			}
		}) {
			ZStack() {
				Image(systemName: "badge.plus.radiowaves.right")
					.font(.system(size: 48))
					.overlay(Circle().stroke(lineWidth: 1).scale(2.5))
			}
			.foregroundColor(.blue)
			.padding()
		}
    }
}

extension AudioRecorderButton {
	final class ViewModel: ObservableObject, Defaultable {
		let recorder: AudioRecorder
		var cancellable: Any? = nil

		init() {
			let recorder : AudioRecorder = ViewModelRegistry.fetch()!
			self.recorder = recorder
			cancellable = self.republish(recorder)
		}
	}
}

extension AudioRecorderButton {
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

struct AudioRecorderButton_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			AudioRecorderButton(path:FileUtils.getDirectory(.inbox))

			AudioRecorderButton(path:FileUtils.getDirectory(.inbox))
		}
		.previewLayout(.fixed(width: 180, height: 180))
    }
}
