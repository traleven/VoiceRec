//
//  InboxDelegate.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 20.05.21.
//

import UIKit

extension InboxDirector : InboxListViewControlDelegate {

	func startRecording(to parent: Model.Egg?, progress: ((TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {
		var parentId = parent?.id ?? FileUtils.getDirectory(.inbox)
		if (nil != parent && parent!.type != .directory) {
			parentId = FileUtils.convertToDirectory(parentId)
		}

		let newId = FileUtils.getNewInboxFile(at: parentId, withExtension: "m4a")
		recorder.start_recording(newId, progress: progress, finish: finish)
	}


	func stopRecording(_ refreshHandle: (URL) -> Void) {
		let url = recorder.finishAudioRecording()
		refreshHandle(url.deletingLastPathComponent())
	}


	func playAudioEgg(_ url: URL, progress: ((TimeInterval, TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {
		if let player = players[url] {
			player.play()
			return
		}
		let player = AudioPlayer(url)
		player.play(onProgress: progress!) { [weak self] (result: Bool) in
			finish?(result)
			self?.players.removeValue(forKey: url)
		}
		players[url] = player
	}


	func stopAllAudio() {
		if recorder.isRecording {
			let _ = recorder.finishAudioRecording()
		}
		for player in players {
			player.value.stop()
		}
	}


	func addTextEgg(to parent: Model.Egg?, _ refreshHandle: @escaping (URL) -> Void) {

		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "inbox.textedit", creator: { (coder: NSCoder) -> InboxTextEditViewController? in
			return InboxTextEditViewController(coder: coder, flow: self, content: nil) { (content: String) in
				var parentId = parent?.id ?? FileUtils.getDirectory(.inbox)
				if (nil != parent && parent!.type != .directory) {
					parentId = FileUtils.convertToDirectory(parentId)
				}

				let newId = FileUtils.getNewInboxFile(at: parentId, withExtension: "txt")
				do {
					try content.write(to: newId, atomically: true, encoding: .utf8)
				} catch let error {
					NSLog("Failed to save text egg to file \(newId): \(error.localizedDescription)")
				}

				refreshHandle(parentId)
			}
		})
		router.present(inboxViewController) {
		}
	}


	func readTextEgg(_ egg: Model.Egg) {
	}


	func delete(_ url: URL) {
		FileUtils.delete(url)
	}


	func share(_ egg: Model.Egg) {
	}
}
