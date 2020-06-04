//
//  TodayViewController.swift
//  OneClickRecorder
//
//  Created by Ivan Dolgushin on 21.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }


	@IBAction func startRecording() {

		self.extensionContext?.open(URL(string: "voicerec://onetap")!, completionHandler: { (_:Bool) in
		})
	}
}
