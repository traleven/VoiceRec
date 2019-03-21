//
//  PhraseLibraryContainerViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhraseLibraryContainerViewController : UIViewController {

	var rootDirectory: URL?
	var parentData: DirectoryData?

	@IBOutlet var backButton: UIBarButtonItem!

	override func viewDidLoad() {
		super.viewDidLoad()

		if rootDirectory == nil {
			rootDirectory = FileUtils.getDirectory("recordings")
		} else {
			backButton.isEnabled = true
		}
	}


	@IBAction func dismissView(_ sender: Any) {

		self.dismiss(animated: true) {
		}
	}


	@IBAction func showInputDialog() {

		let alertController = UIAlertController(title: "Enter phrase", message: "Enter your new phrase", preferredStyle: .alert)

		let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in

			let phrase = alertController.textFields?[0].text
			let phraseUrl = self.rootDirectory!.appendingPathComponent(phrase!, isDirectory: true)
			FileUtils.makePhraseDirectory(phraseUrl)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

		alertController.addTextField { (textField) in
			textField.placeholder = "Enter Phrase"
		}

		alertController.addAction(confirmAction)
		alertController.addAction(cancelAction)

		self.present(alertController, animated: true, completion: nil)
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if let dest = segue.destination as? PhrasesLibraryViewController {
			dest.parentData = parentData
			dest.rootDirectory = rootDirectory
		}
	}
}
