//
//  InboxDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 08.05.21.
//

import UIKit

class InboxDirector: DefaultDirector, AudioPlayerImplementation & AudioRecorderImplementation {
	typealias AudioPlayerType = AudioPlayer

	let recorder: AudioRecorder = AudioRecorder()
	var players: [URL: AudioPlayer] = [:]

	func makeViewController(id: URL) -> UIViewController {
		
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "inbox.list", creator: { (coder: NSCoder) -> InboxListViewController? in
			return InboxListViewController(coder: coder, flow: self, id: id)
		})
		return viewController
	}
}

extension InboxDirector: InboxListViewFlowDelegate {
	func openInboxFolder(url: URL) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let inboxViewController = storyboard.instantiateViewController(identifier: "inbox.list", creator: { (coder: NSCoder) -> InboxListViewController? in
			return InboxListViewController(coder: coder, flow: self, id: url)
		})
		router.push(inboxViewController, onDismiss: nil)
	}

	func openMyNoodles() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Phrases"])
		NotificationCenter.default.post(notification)
	}
}

extension InboxDirector : InboxListViewControlDelegate {

	func startRecording(to parent: Model.Egg?, progress: ((TimeInterval) -> Void)?, finish: ((Bool) -> Void)?) {
		var parentId = parent?.id ?? FileUtils.getDirectory(.inbox)
		if (nil != parent && parent!.type != .directory) {
			parentId = FileUtils.convertToDirectory(parentId)
		}

		let newId = FileUtils.getNewInboxFile(at: parentId, withExtension: "m4a")
		self.startRecording(to: newId, progress: progress, finish: { finish?($0 != nil) })
	}


	func stopRecording(_ refreshHandle: (URL) -> Void) {
		if let url = self.stopRecording() {
			refreshHandle(url.deletingLastPathComponent())
		}
	}


	func playAudioEgg(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		self.playAudio(url, volume: Settings.voice.volume, progress: progress, finish: finish)
	}


	func stopAllAudio() {
		let _ = self.stopRecording()
		self.stopPlayingAll()
	}


	func addTextEgg(to parent: Model.Egg?, _ refreshHandle: @escaping (URL) -> Void) {

		let director = InboxTextEditDirector(router: router)
		let viewController = director.makeViewController(content: nil, applyHandle: { (content: String) in
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
		})
		router.present(viewController, onDismiss: nil)
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


	func convertToPhrase(_ egg: Model.Egg, _ refresh: (() -> Void)?) {

		let user = Model.User.Me
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "\(user.base.prettyDescription)", style: .default, handler: {_ in
			self.convertToPhrase(egg, language: user.base, refresh)
		}))
		alert.addAction(UIAlertAction(title: "\(user.target.prettyDescription)", style: .default, handler: {_ in
			self.convertToPhrase(egg, language: user.target, refresh)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		router.present(alert, onDismiss: nil)
	}


	func convertToPhrase(_ egg: Model.Egg, language: Language, _ refresh: (() -> Void)?) {

		let director = PhraseEditDirector(router: router)
		var phrase =  Model.Phrase(id: FileUtils.getNewPhraseId())
		FileUtils.makePhraseDirectory(phrase.id)

		if egg.type == .text || egg.type == .json {
			if let text = try? String(contentsOf: egg.id) {
				phrase.setText(text, for: language)
				FileUtils.delete(egg.id)
			}
		}
		if egg.type == .audio {
			if let audio = FileUtils.copy(egg.id, to: phrase.id) {
				phrase.setAudio(audio, for: language)
				FileUtils.delete(egg.id)
			}
		}
		phrase.save()

		let viewController = director.makeViewController(phrase: phrase, confirm: {
			$0?.save()
		})
		router.push(viewController, onDismiss: {
			refresh?()
		})
	}


	func share(_ egg: Model.Egg) {

		print("InboxDirector.share(_:) is not implemented yet")
	}
}
