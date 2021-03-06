//
//  ShareViewController.swift
//  Import to Spoken.ly
//
//  Created by Ivan Dolgushin on 02.04.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// https://stackoverflow.com/questions/17041669/creating-a-blurring-overlay-view/25706250

		// only apply the blur if the user hasn't disabled transparency effects
		/*if UIAccessibility.isReduceTransparencyEnabled == false {
			view.backgroundColor = .clear

			let blurEffect = UIBlurEffect(style: .dark)
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			//always fill the view
			blurEffectView.frame = self.view.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

			view.insertSubview(blurEffectView, at: 0)
		} else {
			view.backgroundColor = .black
		}*/
		// Do any additional setup after loading the view.
	}


	func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

	var progress = 0
	var outputItems : [Any] = []
    @IBAction func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

		outputItems = []
		progress = 1
		let inputItems : [NSExtensionItem] = self.extensionContext?.inputItems as! [NSExtensionItem]
		for inputItem in inputItems {

			outputItems.append(inputItem)
			for attachment in inputItem.attachments! {

				progress = progress + 1
				attachment.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: [:]) { (_ encodedData: NSSecureCoding?, _ error: Error?) in
					let url = encodedData as! URL
					let fileData = FileManager.default.contents(atPath: url.path)
					var sharedUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.diplomat.VoiceRec.inbox")!.appendingPathComponent(url.lastPathComponent)
					if FileManager.default.fileExists(atPath: sharedUrl.path) {
						sharedUrl.appendPathExtension(Int.random(in: 0...10000).description)
					}
					try! fileData?.write(to: sharedUrl, options: .atomic)
					self.progress = self.progress - 1
					self.checkCompletion()
				}
			}
		}
		progress = progress - 1
		self.checkCompletion()
    }


	@IBAction func didCancel() {

		self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
	}


    func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }


	func checkCompletion() {

		if progress <= 0 {
			self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
		}
	}
}
