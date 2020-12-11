//
//  ViewModelRegistry.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation
import SwiftUI
import Combine

protocol Defaultable {
	init()
}

struct LazyView<Content: View>: View {
	let build: () -> Content
	init(_ build: @autoclosure @escaping () -> Content) {
		self.build = build
	}
	var body: Content {
		build()
	}
}

struct ViewModelRegistry {
	private static var registry : [HashableType : Any] = [:]

	static func register<ViewModel : ObservableObject>(_ model: ViewModel) {
		ViewModelRegistry.registry[HashableType(ViewModel.self)] = model
	}

	static func fetch<ViewModel: ObservableObject>() -> ViewModel? {
		return ViewModelRegistry.registry[HashableType(ViewModel.self)] as? ViewModel
	}

	private init() {}

	fileprivate struct HashableType : Hashable {
	  static func == (lhs: HashableType, rhs: HashableType) -> Bool {
		return lhs.base == rhs.base
	  }

	  let base: Any.Type

	  init(_ base: Any.Type) {
		self.base = base
	  }

	  func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(base))
	  }
	}
}

fileprivate extension Dictionary {
	subscript<T>(key: T.Type) -> Value? where Key == ViewModelRegistry.HashableType {
		get { return self[ViewModelRegistry.HashableType(key)] }
		set { self[ViewModelRegistry.HashableType(key)] = newValue }
  }
}
