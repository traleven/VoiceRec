//
//  InboxSearchDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 17.06.21.
//

import UIKit

class InboxSearchDirector: DefaultDirector, AudioPlayerImplementation & AudioRecorderImplementation {
	typealias AudioPlayerType = AudioPlayer

	let recorder: AudioRecorder = AudioRecorder()
	var players: [URL: AudioPlayer] = [:]

	func makeViewController(id: URL) -> UIViewController {

		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "inbox.search", creator: { (coder: NSCoder) -> InboxSearchViewController? in
			return InboxSearchViewController(coder: coder, flow: self, id: id)
		})
		return viewController
	}
}

extension InboxSearchDirector: InboxSearchViewFlowDelegate {

	func openInboxFolder(url: URL) {

		let viewController = self.makeViewController(id: url)
		router.push(viewController, onDismiss: nil)
	}
}

extension InboxSearchDirector : InboxSearchViewControlDelegate {

	func playAudioEgg(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		self.playAudio(url, volume: Settings.voice.volume, progress: progress, finish: finish)
	}


	func stopAllAudio() {
		let _ = self.stopRecording()
		self.stopPlayingAll()
	}


	func readTextEgg(_ egg: Model.Egg, _ refreshHandle: @escaping () -> Void) {

		let content = String()
		let director = InboxTextEditDirector(router: router)
		let viewController = director.makeViewController(content: content, applyHandle: { (content: String) in
			do {
				try content.write(to: egg.id, atomically: true, encoding: .utf8)
			} catch let error {
				NSLog("Failed to overwrite text egg to file \(egg.id): \(error.localizedDescription)")
			}
			refreshHandle()
		})
		router.present(viewController, onDismiss: nil)
	}


	func delete(_ url: URL) {

		FileUtils.delete(url)
	}
}
