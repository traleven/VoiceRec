//
//  PhraseLibraryContainerViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 06.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhraseLibraryContainerViewController : UIViewController {

	var rootDirectory: URL!

	override func viewDidLoad() {
		super.viewDidLoad()

		rootDirectory = FileUtils.getDirectory("recordings")
	}

	@IBAction func showInputDialog() {

		//Creating UIAlertController and
		//Setting title and message for the alert dialog
		let alertController = UIAlertController(title: "Enter phrase", message: "Enter your new phrase", preferredStyle: .alert)

		//the confirm action taking the inputs
		let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in

			//getting the input values from user
			let phrase = alertController.textFields?[0].text
			let phraseUrl = self.rootDirectory.appendingPathComponent(phrase!, isDirectory: true)

			do {
				try FileManager.default.createDirectory(at: phraseUrl, withIntermediateDirectories: true)
				NotificationCenter.default.post(name: .refreshPhrases, object: phraseUrl)
			} catch let error {
				NSLog(error.localizedDescription)
			}
		}

		//the cancel action doing nothing
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

		//adding textfields to our dialog box
		alertController.addTextField { (textField) in
			textField.placeholder = "Enter Phrase"
		}

		//adding the action to dialogbox
		alertController.addAction(confirmAction)
		alertController.addAction(cancelAction)

		//finally presenting the dialog box
		self.present(alertController, animated: true, completion: nil)
	}
}
