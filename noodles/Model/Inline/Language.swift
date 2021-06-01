//
//  Language.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 31.05.21.
//

import Foundation

struct Language {
	/// [IETF language tag](https://en.wikipedia.org/wiki/IETF_language_tag)
	/// based on [ISO 639-3](https://iso639-3.sil.org/code_tables/639/data)
	/// with optional [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) country code
	let code: String
	let name: String

	fileprivate init(code: String, name: String) {
		self.code = code
		self.name = name
	}

	init?(rawValue: String) {
		self.init(withCode: rawValue)
	}

	init(withCode code: String) {
		switch code {
		case "eng", "English": self = Language(code: "eng", name: "English")
		case "cmn", "Chinese": self = Language(code: "cmn", name: "Mandarin")
		case "rus":            self = Language(code: "rus", name: "Russian")
		case "ukr":            self = Language(code: "ukr", name: "Ukrainian")
		default:               self = Language(code: code, name: code)
		}
	}
}

extension Language: Equatable {
	static func == (lhs: Language, rhs: Language) -> Bool {
		return lhs.code == rhs.code
	}
}

extension Language: CustomStringConvertible {
	var description: String {
		return name
	}
}

extension Language: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(code)
	}

	var hashValue: Int {
		code.hashValue
	}
}

extension Language: RawRepresentable {
	typealias RawValue = String

	var rawValue: String {
		code
	}

}

extension Language: Decodable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let code = try container.decode(String.self)
		self = Language(withCode: code)
	}
}

extension Language: Encodable {
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(code)
	}
}
