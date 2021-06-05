//
//  PhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class PhrasesDirector: DefaultDirector, AudioPlayerImplementation {

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
		let phraseId = url ?? FileUtils.getNewPhraseId()
		let director = PhraseEditDirector(router: self.router)
		let viewController = director.makeViewController(phrase: Model.Phrase(id: phraseId), confirm: { (phrase: Model.Phrase?) -> Void in
			FileUtils.makePhraseDirectory(phraseId)
			phrase?.save()
		})
		router.push(viewController, onDismiss: refresh)
	}
}

extension PhrasesDirector : PhrasesListViewControlDelegate {
	func delete(_ url: URL) {
		FileUtils.delete(url)
	}
}
