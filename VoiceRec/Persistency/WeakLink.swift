//
//  WeakLink.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 08.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import Foundation

struct WeakLink<Element : GlobalIdentifiable> : Codable {

	var item : Element?

	init(_ item : Element?) {
		self.item = item
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let id = try container.decode(Element.ID.self)
		item = try? .init(at: id)
    }

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(item?.id)
	}
}

protocol GlobalIdentifiable : Identifiable where ID : Codable {
    /// The stable identity of the entity associated with `self`.
    var id: Self.ID { get }
	init(at: Self.ID) throws
}
