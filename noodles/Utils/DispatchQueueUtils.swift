//
//  DispatchQueueUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 02.06.21.
//

import Foundation

fileprivate let mainQueueKey = DispatchSpecificKey<Bool>()

extension DispatchQueue {
	public static func runOnMain(_ block: @escaping () -> Void) {
		if getSpecific(key: mainQueueKey) ?? false {
			block()
		} else {
			DispatchQueue.main.async(execute: block)
		}
	}
}
