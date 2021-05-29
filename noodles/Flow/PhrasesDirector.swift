//
//  PhrasesDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 28.05.21.
//

import UIKit

class PhrasesDirector: DefaultDirector {
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
		let inboxViewController = storyboard.instantiateViewController(identifier: "phrase.edit", creator: { (coder: NSCoder) -> PhraseEditViewController? in
			let phraseId = url ?? FileUtils.getNewPhraseId()
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
}
