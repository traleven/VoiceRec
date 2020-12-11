//
//  ObservableUtils.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 11.12.20.
//

import Foundation
import SwiftUI
import Combine

extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher  {
	func republish<T: ObservableObject>(_ object: T) -> AnyCancellable {
		return object.objectWillChange.sink { [weak self] (_) in
			self?.objectWillChange.send()
		   }
	}
}
