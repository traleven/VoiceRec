//
//  InboxLibraryViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 20.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import opus

class InboxLibraryViewController : AudioLibraryViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let sharedUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.diplomat.VoiceRec.inbox")!

		let files = try! FileManager.default.contentsOfDirectory(at: sharedUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

		for url in files {

			if (!url.hasDirectoryPath) {
				transcode(url.path, FileUtils.getDirectory("INBOX").appendingPathComponent(url.lastPathComponent).appendingPathExtension("wav").path)
				try! FileManager.default.removeItem(at: url)
			}
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let cell = tableView.cellForRow(at: indexPath) as! AudioCell
		let data = cell.data!
		let ac = UIAlertController(title: "Process item", message: cell.title.text, preferredStyle: .actionSheet)
		ac.popoverPresentationController?.sourceView = tableView

		ac.addAction(UIAlertAction(title: "Play/Stop", style: .default) {
			(_) in cell.toggle_play(nil)
		})

		ac.addAction(UIAlertAction(title: "Convert to phrase (\(Settings.language.native))", style: .destructive) {
			(_) in self.addAudio(withData: data, of: Settings.language.native)
		})

		ac.addAction(UIAlertAction(title: "Convert to phrase (\(Settings.language.foreign))", style: .destructive) {
			(_) in self.addAudio(withData: data, of: Settings.language.foreign)
		})

		ac.addAction(UIAlertAction(title: "Rename", style: .default) {
			(result : UIAlertAction) in self.renameInboxItem(withData: data)
		})

		ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
			(result : UIAlertAction) in self.deleteInboxItem(withData: data)
		})

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(ac, animated: true) {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}


	func deleteInboxItem(withData: AudioData) {

		let confirm = UIAlertController(title: "Are you sure?", message: "This action will irreversibly delete the audio recording \"\(withData.filename ?? "")\"", preferredStyle: .actionSheet)
		confirm.popoverPresentationController?.sourceView = self.view

		confirm.addAction(UIAlertAction(title: "Delete", style: .destructive)
		{
			(result : UIAlertAction) in
			do {
				try FileManager.default.removeItem(at: withData.url)
				self.refresh_data()
			} catch {}
		})
		confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		self.present(confirm, animated: true)
	}


	func renameInboxItem(withData: AudioData) {
		
		let ac = UIAlertController(title: "Rename \(withData.filename ?? "")", message: "Enter new name for the entry", preferredStyle: .alert)

		let confirmAction = UIAlertAction(title: "Rename", style: .default) { (_) in

			let filename = ac.textFields?[0].text ?? ""
			if filename.count > 0 {
				do {
					let root = withData.url.deletingLastPathComponent()
					let newUrl = root.appendingPathComponent(filename)
					try FileManager.default.moveItem(
						at: withData.url!,
						to: newUrl)
				} catch {
					NSLog(error.localizedDescription)
				}
				self.refresh_data()
			}
		}

		ac.addTextField { (textField) in
			textField.placeholder = "New File Name"
			textField.text = withData.url.lastPathComponent
		}

		ac.addAction(confirmAction)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(ac, animated: true, completion: nil)
	}


	func addAudio(withData: AudioData, of language: String) {

		let ac = UIAlertController(title: "Enter the phrase", message: "For entry \"\(withData.filename ?? "")\"", preferredStyle: .alert)

		let confirmAction = UIAlertAction(title: "Convert to \(language)", style: .default) { (_) in

			let filename = ac.textFields?[0].text ?? ""
			if filename.count > 0 {
				do {
					let root = FileUtils.getDirectory("recordings")
					let phraseUrl = root.appendingPathComponent(filename, isDirectory: true)
					FileUtils.makePhraseDirectory(phraseUrl)
					try FileManager.default.moveItem(
						at: withData.url!,
						to: phraseUrl.appendingPathComponent("\(language).m4a"))
				} catch {
					NSLog(error.localizedDescription)
				}
				self.refresh_data()
			}
		}

		ac.addTextField { (textField) in
			textField.placeholder = "New File Name"
			textField.text = withData.url.deletingPathExtension().lastPathComponent
		}

		ac.addAction(confirmAction)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(ac, animated: true, completion: nil)
	}


	let SAMPLE_RATE : opus_int32 = 48000
	let FRAME_SIZE : opus_int32 = 5760
	let CHANNELS : opus_int32 = 1


	func convertOpus(_ data: AudioData) {


		transcode(data.url!.path, data.url.appendingPathExtension(".wav").path)
		return

		let opusData = FileManager.default.contents(atPath: data.url.path)!

		var opusError : opus_int32 = OPUS_OK
		let decoder = opus_decoder_create(SAMPLE_RATE, CHANNELS, &opusError)!

		var result = Data()
		result.append(decodeOpusPacket(decoder, opusData))

		try! result.write(to: data.url.appendingPathExtension(".wav"))
	}


	func decodeOpusPacket(_ decoder: OpaquePointer, _ data: Data) -> Data {

		let result = data.withUnsafeBytes { (_ unsafeData: UnsafePointer<UInt8>) -> Data? in

			var pcmData = Data(capacity: Int(FRAME_SIZE * CHANNELS * /*sizeof(opus_int16)*/2))
			let samples = pcmData.withUnsafeMutableBytes({ (_ pcm: UnsafeMutablePointer<opus_int16>) -> opus_int32 in
				return opus_decode(decoder, unsafeData, opus_int32(data.count), pcm, 160, 0)
			})

			pcmData.removeSubrange(pcmData.startIndex.advanced(by: Int(samples))...)
			return pcmData
		}

		return result!
	}
}
