//
//  MarqueeText.swift
//  https://www.reddit.com/r/SwiftUI/comments/ettnux/marquee_scrolling_text/
//
//  Created by https://www.reddit.com/user/prio732/
//

import SwiftUI

struct MarqueeText: View {
	@State var text = ""
	@State private var animate = false
	private let animationOne: Animation = Animation.linear(duration: 5).delay(3).repeatForever(autoreverses: false)

	var body : some View {
		let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))
		return ZStack {
			GeometryReader { geometry in
				Text(self.text).lineLimit(1)
					.font(.subheadline)
					.offset(x: self.animate ? -stringWidth * 2 : 0)
					.animation(self.animationOne)
					.onAppear() {
						if geometry.size.width < stringWidth {
							self.animate = true
						}
				}
				.fixedSize(horizontal: true, vertical: false)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

				Text(self.text).lineLimit(1)
					.font(.subheadline)
					.offset(x: self.animate ? 0 : stringWidth * 2)
					.animation(self.animationOne)
					.fixedSize(horizontal: true, vertical: false)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
			}
		}
	}
}

extension String {

	func widthOfString(usingFont font: UIFont) -> CGFloat {
		let fontAttributes = [NSAttributedString.Key.font: font]
		let size = self.size(withAttributes: fontAttributes)
		return size.width
	}

	func heightOfString(usingFont font: UIFont) -> CGFloat {
		let fontAttributes = [NSAttributedString.Key.font: font]
		let size = self.size(withAttributes: fontAttributes)
		return size.height
	}

	func sizeOfString(usingFont font: UIFont) -> CGSize {
		let fontAttributes = [NSAttributedString.Key.font: font]
		return self.size(withAttributes: fontAttributes)
	}
}

struct MarqueeText_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VStack (alignment: .leading) {
				MarqueeText(text: "This is some very long text for a song")
			}
			.frame(width: 230, height: 30)
			.clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
		}
		.previewLayout(.fixed(width: 480, height: 80))
	}
}
