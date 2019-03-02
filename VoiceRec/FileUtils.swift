//
//  FileUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 01.03.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

class FileUtils {

	class func getDocumentsDirectory() -> URL
	{
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
}
