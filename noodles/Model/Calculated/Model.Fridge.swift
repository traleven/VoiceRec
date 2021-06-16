//
//  Model.Fridge.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 10.12.20.
//

import Foundation

extension Model {
	struct Fridge<ValueType: IdInitializable & Traversable> {
		var root : ValueType.ID

		init(_ root : ValueType.ID) {
			self.root = root
		}

		func fetch() -> [ValueType] {
			return fetch(at: root)
		}

		func fetch(ctor: (ValueType.ID) -> ValueType) -> [ValueType] {
			return fetch(at: root, ctor: ctor)
		}

		func fetch(at url : ValueType.ID?) -> [ValueType] {
			return fetch(at: url ?? root)
		}

		func fetch(at url : ValueType.ID) -> [ValueType] {
			let children = ValueType.getChildren(url)
			return children.map { (id: ValueType.ID) -> ValueType in
				ValueType(id: id)
			}
		}

		func fetch(at url : ValueType.ID, ctor: (ValueType.ID) -> ValueType) -> [ValueType] {
			let children = ValueType.getChildren(url)
			return children.map { (id: ValueType.ID) -> ValueType in
				ctor(id)
			}
		}
	}
}
