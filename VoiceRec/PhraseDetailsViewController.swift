//
//  PhraseDetailsViewController.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class PhraseDetailsViewController: UIViewController {

	@IBOutlet var navTitle: UINavigationItem!

	var root: URL?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}


	override func viewWillAppear(_ animated: Bool) {

		navTitle?.title = root?.lastPathComponent
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier != "",
			let vc = segue.destination as? RecorderViewController {

			vc.setData(directoryUrl: root!, language: Settings.language.getLanguage(segue.identifier!), phrase: root!.lastPathComponent)
		}
	}

	
	func setRootDirectory(_ url: URL!) {

		root = url
		navTitle?.title = url.lastPathComponent
	}


	@IBAction func goBack(_ sender: Any) {

		dismiss(animated: true) {
		}
	}


	@IBAction func selfDestruct(_ sender: Any) {

		let ac = UIAlertController(title: "Delete phrase?", message: "Are you sure?", preferredStyle: .actionSheet)
		ac.popoverPresentationController?.sourceView = self.view

		ac.addAction(UIAlertAction(title: "Delete", style: .destructive)
		{
			(result : UIAlertAction) -> Void in
			_ = self.navigationController?.popViewController(animated: true)
			do {
				try FileManager.default.removeItem(at: self.root!)
				self.goBack(sender)
			} catch let error {
				NSLog(error.localizedDescription)
			}
		})

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel)
		{
			(result : UIAlertAction) -> Void in
			_ = self.navigationController?.popViewController(animated: true)
		})

		self.present(ac, animated: true)
	}
}

