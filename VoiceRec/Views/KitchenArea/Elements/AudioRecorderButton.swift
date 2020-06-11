//
//  AudioRecorderButton.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct AudioRecorderButton: View {
	@EnvironmentObject var recorder: AudioRecorder
	var path: URL

	var body: some View {
		recorder.isRecording
		? Button(action: {
			self.recorder.finishAudioRecording()
		}) {
			Image("mic_active")
				.renderingMode(.original)
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

			self.recorder.start_recording(FileUtils.getNewInboxFile(at:self.path.deletingPathExtension(), withName: "", andExtension: "m4a"), progress: nil) { (success: Bool) in
			}
		}) {
			Image("mic_normal")
				.renderingMode(.original)
		}
    }
}

struct AudioRecorderButton_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			AudioRecorderButton(path:FileUtils.getDirectory("INBOX"))
				.environmentObject(AudioRecorder())

			AudioRecorderButton(path:FileUtils.getDirectory("INBOX"))
				.environmentObject(AudioRecorder())
		}
		.environmentObject(AudioRecorder())
		.previewLayout(.fixed(width: 180, height: 180))
    }
}
