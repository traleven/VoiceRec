//
//  InboxLibraryViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 20.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class InboxLibraryViewController : AudioLibraryViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let cell = tableView.cellForRow(at: indexPath) as! AudioCell
		let data = cell.data!
		let ac = UIAlertController(title: "Process item", message: cell.title.text, preferredStyle: .actionSheet)

		ac.addAction(UIAlertAction(title: "Play/Stop", style: .default) {
			(_) in cell.toggle_play(nil)
		})

		ac.addAction(UIAlertAction(title: "Convert to phrase (English)", style: .destructive) {
			(_) in self.addAudio(withData: data, of: "English")
		})

		ac.addAction(UIAlertAction(title: "Convert to phrase (Chinese)", style: .destructive) {
			(_) in self.addAudio(withData: data, of: "Chinese")
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

		let confirm = UIAlertController(title: "Are you sure?", message: "This action will irreveribly delete the audio recording \"\(withData.filename ?? "")\"", preferredStyle: .actionSheet)

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
}
