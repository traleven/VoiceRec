//
//  AudioVisualizer.swift
//  Spoken.ly
//
//  Created by Ivan Dolgushin on 13.05.19.
//  Copyright © 2019 traleven. All rights reserved.
//

import UIKit

class AudioVisualizerView: UIView {

	// Bar width
	var barWidth: CGFloat = 4.0
	// Indicate that waveform should draw active/inactive state
	var active = false {
		didSet {
			if self.active {
				self.color = UIColor.red.cgColor
			}
			else {
				self.color = UIColor.gray.cgColor
			}
		}
	}
	// Color for bars
	var color = UIColor.gray.cgColor
	// Given waveforms
	var waveforms: [Int] = Array(repeating: 0, count: 20)

	private var idx : Int = 0

	// MARK: - Init
	override init (frame : CGRect) {
		super.init(frame : frame)
		self.backgroundColor = UIColor.clear
	}

	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		self.backgroundColor = UIColor.clear
	}

	func push(value : Int) {
		waveforms[idx] = value
		idx = (idx + 1) % waveforms.count
	}

	func clearWaveform() {
		waveforms = Array(repeating: 0, count: waveforms.count)
	}

	// MARK: - Draw bars
	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else {
			return
		}
		context.clear(rect)
		context.setFillColor(self.backgroundColor!.cgColor)
		context.fill(rect)
		context.setLineWidth(2)
		context.setStrokeColor(self.tintColor.cgColor)
		let w = rect.size.width
		let h = rect.size.height
		self.barWidth = w / CGFloat(self.waveforms.count)
		let t = Int(w / self.barWidth)
		let s = max(0, self.waveforms.count - t)
		let m = h / 2
		let r = self.barWidth / 2
		let x = m - r
		var bar: CGFloat = 0
		for i in s ..< self.waveforms.count {
			var v = h * CGFloat(self.waveforms[i]) / 50.0
			if v > x {
				v = x
			}
			else if v < 3 {
				v = 3
			}
			let oneX = bar * self.barWidth
			var oneY: CGFloat = 0
			let twoX = oneX + r
			var twoY: CGFloat = 0
			var twoS: CGFloat = 0
			var twoE: CGFloat = 0
			var twoC: Bool = false
			let threeX = twoX + r
			let threeY = m
			if i % 2 == 1 {
				oneY = m - v
				twoY = m - v
				twoS = CGFloat.pi
				twoE = 0
				twoC = false
			}
			else {
				oneY = m + v
				twoY = m + v
				twoS = CGFloat.pi
				twoE = 0
				twoC = true
			}
			context.move(to: CGPoint(x: oneX, y: m))
			context.addLine(to: CGPoint(x: oneX, y: oneY))
			context.addArc(center: CGPoint(x: twoX, y: twoY), radius: r, startAngle: twoS, endAngle: twoE, clockwise: twoC)
			context.addLine(to: CGPoint(x: threeX, y: threeY))
			context.strokePath()
			bar += 1
		}
	}
}

class AudioDataSource: NSObject {

	@IBOutlet var visualizerView : AudioVisualizerView!
	private var timer : Timer!

	@IBAction func startVisualizing() {

		self.visualizerView.clearWaveform()
		timer = Timer(timeInterval: 0.025, repeats: true, block: { (Timer) in
			self.visualizerView.push(value: Int.random(in: -10...10))
			self.visualizerView.setNeedsDisplay()
		})
		RunLoop.main.add(timer, forMode: .common)
	}

	@IBAction func stopVisualizing() {

		timer.invalidate()
	}
}
