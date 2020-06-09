//
//  AudioRecorderButton.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 08.06.20.
//

import SwiftUI

struct AudioRecorderButton: View {
	@EnvironmentObject var recorder: AudioRecorder

	var body: some View {
		recorder.isRecording
		? Button(action: {
			self.recorder.finishAudioRecording()
		}) {
			Image("mic_active")
				.renderingMode(.original)
		}
		: Button(action: {
			self.recorder.start_recording(FileUtils.getNewInboxFile(withName: "Recording", andExtension: "m4a"), progress: nil) { (success: Bool) in
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
			AudioRecorderButton()
				.environmentObject(AudioRecorder())
			AudioRecorderButton()
				.environmentObject(AudioRecorder())
		}
		.previewLayout(.fixed(width: 180, height: 180))
    }
}
