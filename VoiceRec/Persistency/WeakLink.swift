//
//  WeakLink.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

struct WeakLink<Element : GlobalIdentifiable> : Codable {

	var id : Element.ID?
	private var _item : Element?
	var item : Element? {
		mutating get {
			if _item == nil && id != nil {
				_item = WeakLink<Element>.loadBy(id: id!)
			}
			return _item
		}
	}

	init(_ item : Element?) {
		self.id = item?.id
		self._item = item
	}

	init(_ id : Element.ID) {
		self.id = id
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		id = try container.decode(Element.ID.self)
		_item = nil
    }

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(id)
	}

	static func loadBy(id: Element.ID) -> Element? {
		guard let url = Element.index[id] else {
			return nil
		}
		guard FileManager.default.fileExists(atPath: url.path) else {
			return nil
		}
		return Element.with(contentOf: url)
	}
}

protocol GlobalIdentifiable : Identifiable where ID : Codable {
    /// The stable identity of the entity associated with `self`.
	static var index : [Self.ID : URL] { get }
    var id: Self.ID { get }
	static func with(contentOf file: URL) -> Self?
}
