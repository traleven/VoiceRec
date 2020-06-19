//
//  PlayButton.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 19.06.20.
//

import SwiftUI

struct PlayButton: View {
	@ObservedObject var player : AudioPlayer

	var body: some View {
		player.isPlaying
		? Button(
			action: {
				self.player.stop()
			}
		) {
			Image("playback_pause")
				.foregroundColor(.blue)
		}
		: Button(
			action: {
				self.player.play()
			}
		) {
			Image("playback_play")
				.foregroundColor(.blue)
		}
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
		PlayButton(player: AudioPlayer(Bundle.main.url(forResource: "some air", withExtension: "m4a")))
    }
}
