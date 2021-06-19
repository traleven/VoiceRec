//
//  GlobalIdentifiable.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 20.06.21.
//

import Foundation

protocol GlobalIdentifiable : Identifiable where ID : Codable {
	/// The stable identity of the entity associated with `self`.
	var id: Self.ID { get }
	static func getBy(id: Self.ID) -> Self?
}

protocol Persistent : GlobalIdentifiable {
	static var index : [Self.ID : URL] { get }
	static func with(contentOf file: URL) -> Self?
}
