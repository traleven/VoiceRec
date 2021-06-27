//
//  InboxSearchDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 17.06.21.
//

import UIKit

class InboxSearchDirector: DefaultDirector, AudioPlayerImplementation & AudioRecorderImplementation {
	typealias AudioPlayerType = AudioPlayer
	typealias ApplyHandler = (Model.Egg?) -> Void

	let recorder: AudioRecorder = AudioRecorder()
	var players: [URL: AudioPlayer] = [:]

	func makeViewController(onApply: ApplyHandler?) -> UIViewController {

		let storyboard = getStoryboard(name: "Kitchen", bundle: nil)
		let navigation = storyboard.instantiateViewController(identifier: "navigation") as UINavigationController
		let viewController = storyboard.instantiateViewController(identifier: "inbox.search", creator: { (coder: NSCoder) -> InboxSearchViewController? in
			return InboxSearchViewController(coder: coder, flow: self, id: FileUtils.getDirectory(.inbox), onApply: onApply)
		})
		navigation.setViewControllers([viewController], animated: false)
		self.router = NavigationControllerRouter(controller: navigation)
		return navigation
	}

	func makeViewController(id: URL, onApply: ApplyHandler?) -> UIViewController {

		let router = self.router
		let storyboard = getStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "inbox.search", creator: { (coder: NSCoder) -> InboxSearchViewController? in
			return InboxSearchViewController(coder: coder, flow: self, id: id, onApply: { (egg: Model.Egg?) in
				if let egg = egg {
					let alert = UIAlertController(title: nil, message: "Do you want to set this \(egg.type)?", preferredStyle: .actionSheet)
					alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_: UIAlertAction) in
						onApply?(egg)
					}))
					alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
					router.present(alert, onDismiss: nil)
				} else {
					onApply?(egg)
				}
			})
		})
		return viewController
	}
}

extension InboxSearchDirector: InboxSearchViewFlowDelegate {

	func openInboxFolder(url: URL, onApply: ApplyHandler?) {

		let viewController = self.makeViewController(id: url, onApply: onApply)
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

		let content = try? String(contentsOf: egg.id)
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
