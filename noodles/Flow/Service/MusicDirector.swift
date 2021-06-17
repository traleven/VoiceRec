//
//  MusicDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 16.06.21.
//

import UIKit

class MusicDirector: DefaultDirector, AudioPlayerImplementation, LessonSaveImplementation {
	typealias AudioPlayerType = AudioPlayer

	var players: [URL: AudioPlayer] = [:]

	func makeViewController() -> UIViewController {
		let storyboard = UIStoryboard(name: "Service", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "service.music", creator: { (coder: NSCoder) -> MusicViewController? in
			return MusicViewController(coder: coder, flow: self)
		})
		return viewController
	}
}

extension MusicDirector: MusicViewFlowDelegate {
}

extension MusicDirector: MusicViewControlDelegate {

	func playMusic(_ url: URL, volume: Float, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: PlayerResultCallback?) {

		playAudio(url, at: FileUtils.getDirectory(.music), volume: volume, progress: progress, finish: finish)
	}

	
	func stopMusic() {

		_ = stopPlaying(FileUtils.getDirectory(.music))
	}


	func stopAllAudio() {

		self.stopPlayingAll()
	}
}
