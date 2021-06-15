//
//  SliderWithHint.swift
//  Noodles
//
//  Created by Ivan Dolgushin on 05.06.21.
//

import UIKit

@IBDesignable
class SliderWithHint: UISlider {
	private var hintView: UILabel?

	@IBInspectable var format: String = "%.1f" {
		didSet { setNeedsDisplay() }
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		self.addTarget(self, action: #selector(showHint), for: .touchDown)
		self.addTarget(self, action: #selector(hideHint), for: .touchUpInside)
		self.addTarget(self, action: #selector(hideHint), for: .touchUpOutside)
		self.addTarget(self, action: #selector(hideHint), for: .touchCancel)
		self.addTarget(self, action: #selector(updateHint), for: .valueChanged)
	}


	fileprivate func makeLabel() -> UILabel {

		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .primaryText
		label.backgroundColor = .secondaryBackground
		label.font = UIFont.systemFont(ofSize: 24)
		label.numberOfLines = 1
		label.layer.masksToBounds = true
		label.layer.cornerRadius = 5
		label.alpha = 0
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
			label.alpha = 1
		} completion: { (result: Bool) in
		}

		UIView.animate(withDuration: 0.5) {
		}
		return label
	}

	@objc fileprivate func showHint() {

		hintView = makeLabel()
		if let hintView = hintView {
			self.addSubview(hintView)
			updateHint()
		}
	}


	@objc fileprivate func hideHint() {

		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
			self.hintView?.alpha = 0
		} completion: { (result: Bool) in
			self.hintView?.removeFromSuperview()
			self.hintView = nil
		}
	}


	@objc fileprivate func updateHint() {

		if let hintView = hintView {
			hintView.text = String(format: format, self.value)

			let parent = self.bounds
			let trackRect = self.trackRect(forBounds: self.bounds)
			let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: self.value)
			let size = hintView.intrinsicContentSize
			hintView.frame = CGRect(
				x: thumbRect.midX - parent.minX - 0.5 * size.width,
				y: thumbRect.minY - parent.minY - 2 * size.height,
				width: size.width,
				height: size.height
			)
		}
	}
}

extension UIView {

	var rootview: UIView? {
		self.superview != nil ? self.superview?.rootview : self
	}
}
