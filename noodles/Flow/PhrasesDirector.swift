//
//  PhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class PhrasesDirector: DefaultDirector, AudioPlayerImplementation & AudioRecorderImplementation {

	let recorder: AudioRecorder = AudioRecorder()
	var players: [URL: AudioPlayer] = [:]
}

extension PhrasesDirector : PhrasesListViewFlowDelegate {

	func openInbox() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Inbox"])
		NotificationCenter.default.post(notification)
	}

	func openLessons() {
		let notification = Notification(name: .selectTab, object: nil, userInfo: ["page" : "Lessons"])
		NotificationCenter.default.post(notification)
	}

	func addNewPhrase(_ refresh: RefreshHandle?) {
		openPhrase(nil, refresh)
	}

	func openPhrase(_ url: URL?, _ refresh: RefreshHandle?) {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let phraseId = url ?? FileUtils.getNewPhraseId()
		let inboxViewController = storyboard.instantiateViewController(identifier: "phrase.edit", creator: { (coder: NSCoder) -> PhraseEditViewController? in
			return PhraseEditViewController(coder: coder, flow: self, content: Model.Phrase(id: phraseId), applyHandle: { (phrase: Model.Phrase?) -> Void in

				FileUtils.makePhraseDirectory(phraseId)
				phrase?.save()
			})
		})
		router.push(inboxViewController, onDismiss: refresh)
	}
}

extension PhrasesDirector : PhrasesListViewControlDelegate {
	func delete(_ url: URL) {
		FileUtils.delete(url)
	}
}

extension PhrasesDirector : PhraseEditViewFlowDelegate {
	func openOptionsMenu(_ phrase: Model.Phrase, language: Language, _ refresh: @escaping (Model.Phrase) -> Void) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//		alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_: UIAlertAction) in
//			print("Audio sharing is not implemented yet")
//		}))
		if !phrase.text(language).isEmpty {
			alert.addAction(UIAlertAction(title: "Copy to clipboard", style: .default, handler: { (_: UIAlertAction) in
				UIPasteboard.general.string = phrase.text(language)
			}))
		}
		if phrase.audio(language) != nil {
			alert.addAction(UIAlertAction(title: "Delete audio", style: .destructive, handler: { (_: UIAlertAction) in
				guard let audioUrl = phrase.audio(language) else { return }
				FileUtils.delete(audioUrl)
				var newPhrase = phrase
				newPhrase.setAudio(nil, for: language)
				refresh(newPhrase)
			}))
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		router.present(alert, onDismiss: nil)
	}
}
