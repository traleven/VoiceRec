//
//  ImageUtils.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 11.06.21.
//

import UIKit
import ImageIO

extension UIImage {

	func resizedImage(for size: CGSize) -> UIImage? {
		let options: [CFString: Any] = [
			kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
			kCGImageSourceCreateThumbnailWithTransform: true,
			kCGImageSourceShouldCacheImmediately: true,
			kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
		]

		guard let pngData = self.pngData() else { return nil }
		guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
			let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
		else {
			return nil
		}

		return UIImage(cgImage: image)
	}
}
