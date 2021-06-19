//
//  PhraseEditDirector.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 03.06.21.
//

import UIKit

class PhraseEditDirector: DefaultDirector, AudioPlayerImplementation & AudioRecorderImplementation {
	typealias AudioPlayerType = AudioPlayer

	let recorder: AudioRecorder = AudioRecorder()
	var players: [URL: AudioPlayer] = [:]

	func makeViewController(phrase: Model.Phrase, confirm: ((Model.Phrase?) -> Void)?) -> UIViewController {
		let storyboard = UIStoryboard(name: "Kitchen", bundle: nil)
		let viewController = storyboard.instantiateViewController(identifier: "phrase.edit", creator: { (coder: NSCoder) -> PhraseEditViewController? in
			return PhraseEditViewController(coder: coder, flow: self, content: phrase, applyHandle: confirm)
		})
		return viewController
	}
}

extension PhraseEditDirector : PhraseEditViewFlowDelegate {

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

	func searchInbox(_ phrase: Model.Phrase, for language: Language, _ refresh: ModelRefreshHandle?) {

		let director = InboxSearchDirector(router: router)
		let viewController = director.makeViewController(onApply: { [weak self] in
			guard let egg = $0 else {
				self?.router.dismiss(animated: true, completion: nil)
				return
			}

			switch egg.type {
			case .audio:
				var phrase = phrase
				if let audio = FileUtils.copy(egg.id, to: phrase.id) {
					FileUtils.delete(egg.id)
					phrase.setAudio(audio, for: language)
					refresh?(phrase)
				}
			case .text, .json:
				var phrase = phrase
				if let text = try? String(contentsOf: egg.id) {
					FileUtils.delete(egg.id)
					phrase.setText(text, for: language)
					refresh?(phrase)
				}
			default:
				print("Unsupported egg type \(egg.type): \(egg.name)")
			}
			self?.router.dismiss(animated: true, completion: nil)
		})
		router.present(viewController) {
		}
	}
}

extension PhraseEditDirector : PhraseEditViewControlDelegate {
	typealias RefreshHandle = () -> Void

	func startRecording(to phrase: URL, for language: Language, progress: ((TimeInterval) -> Void)?, finish: ((URL?) -> Void)?) {
		let audioFile = FileUtils.getNewPhraseFile(for: phrase, withExtension: "\(language).m4a")
		self.startRecording(to: audioFile, progress: progress, finish: finish)
	}

	func stopRecording(_ refreshHandle: RefreshHandle?) {
		let _ = self.stopRecording()
		refreshHandle?()
	}

	func startPlaying(_ url: URL, progress: PlayerProgressCallback?, finish: PlayerResultCallback?) {
		self.playAudio(url, volume: Settings.voice.volume, progress: progress, finish: finish)
	}

	func stopPlaying(_ url: URL, _ refreshHandle: RefreshHandle?) {
		let _ = self.stopPlaying(url)
		refreshHandle?()
	}

	func stopAllAudio() {
		let _ = self.stopRecording()
		self.stopPlayingAll()
	}
}
