//
//  StringRepresentable.swift
//  Noodles
//
//  Created by Ivan on 27/07/2025.
//

import Foundation

public protocol StringRepresentable {
    associatedtype StringRepresentation : StringProtocol
    var asString: StringRepresentation { get }
}
