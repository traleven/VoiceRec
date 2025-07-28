//
//  AudioRecord.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
final class AudioRecord {
    @Attribute(.externalStorage, .allowsCloudEncryption)
    var data : Data?
    
    init(data: Data? = nil) {
        self.data = data
    }
}
