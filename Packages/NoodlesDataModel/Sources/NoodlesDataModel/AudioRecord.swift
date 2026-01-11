//
//  AudioRecord.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
public final class AudioRecord {
    @Attribute(.externalStorage, .allowsCloudEncryption)
    public var data : Data?
    
    public init(data: Data? = nil) {
        self.data = data
    }
}
