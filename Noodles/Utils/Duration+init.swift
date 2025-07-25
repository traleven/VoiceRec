//
//  Duration+init.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import Foundation

extension Duration {
    static func minutes(_ minutes: Int) -> Duration {
        .seconds(minutes * 60)
    }
    
    static func hours(_ hours: Int) -> Duration {
        .minutes(hours * 60)
    }
    
    func add(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Duration {
        self + .hours(hours) + .minutes(minutes) + .seconds(seconds)
    }
}
