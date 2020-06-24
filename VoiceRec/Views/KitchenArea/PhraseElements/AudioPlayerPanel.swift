//
//  AudioPlayerPanel.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 19.06.20.
//

import SwiftUI
import SwiftUIX

struct AudioPlayerPanel: View {
	@ObservedObject var player : AudioPlayer
	@ObservedObject var recorder : AudioRecorder

	init(_ url: URL?) {
		player = AudioPlayer(url)
		recorder = AudioRecorder()
	}

    var body: some View {
		VStack() {
			HStack(alignment: .bottom) {
				Button(
					action: {
					}
				) {
					Image("remove")
						.foregroundColor(.orange)
				}
				Spacer()
				PlayButton(player: player)
				Spacer()
				Button(
					action: {
					}
				) {
					Image("list_add")
						.foregroundColor(.gray)
				}
			}
			LinearProgressBar(CGFloat(player.progress01))
				.fixedSize(horizontal: false, vertical: true)
				.foregroundColor(.blue)
		}
    }
}

struct AudioPlayerPanel_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			AudioPlayerPanel(FileUtils.getDefaultsDirectory(.music).appendingPathComponent("some air.m4a"))
		}
		.previewLayout(.fixed(width: 480, height: 160))
    }
}
