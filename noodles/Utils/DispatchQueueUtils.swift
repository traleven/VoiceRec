//
//  DispatchQueueUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 02.06.21.
//

import Foundation

fileprivate let mainQueueKey = DispatchSpecificKey<Bool>()

extension DispatchQueue {

	/// Run `block` synchronously if the calling queue is main; dispatch `block` async to the main queue otherwise
	public static func runOnMain(_ block: @escaping () -> Void) {
		if getSpecific(key: mainQueueKey) ?? false {
			block()
		} else {
			DispatchQueue.main.async(execute: block)
		}
	}

	/// Run `block` synchronously if the calling queue is main; dispatch `block` synchronously to the main queue otherwise
	public static func syncToMain(_ block: @escaping () -> Void) {
		if getSpecific(key: mainQueueKey) ?? false {
			block()
		} else {
			DispatchQueue.main.sync(execute: block)
		}
	}
}
