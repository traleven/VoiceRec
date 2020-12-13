//
//  ViewModifiers.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 11.12.20.
//

import Foundation
import SwiftUI
import SwiftUIX
import Introspect

extension View {
	@ViewBuilder func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
		if conditional {
			content(self)
		} else {
			self
		}
	}

	@ViewBuilder func `ifKeyboardIsShowing`<Content: View>(content: (Self) -> Content) -> some View {
		if Keyboard.main.isShowing {
			content(self)
		} else {
			self
		}
	}

	@ViewBuilder func `ifKeyboardIsNotShowing`<Content: View>(content: (Self) -> Content) -> some View {
		if !Keyboard.main.isShowing {
			content(self)
		} else {
			self
		}
	}

	func ifKeyboard<Destination: View>(isShown: @escaping (_ViewModifier_Content<IfKeyboardActive<Destination>>) -> Destination, isHidden: @escaping (_ViewModifier_Content<IfKeyboardActive<Destination>>) -> Destination) -> some View {
		let mod = IfKeyboardActive(onActive: isShown, onInactive: isHidden)
		return modifier(mod)
	}

	public func hideNavigationBarIfKeyboardActive() -> some View {
		modifier(HideNavigationBarIfKeyboardActive())
	}

	public func hideTabBarIfKeyboardActive() -> some View {
		modifier(HideTabBarIfKeyboardActive())
	}
}

struct HideNavigationBarIfKeyboardActive: ViewModifier {
	@ObservedObject var keyboard: Keyboard = .main

	func body(content: Content) -> some View {
		content.navigationBarHidden(keyboard.isShowing)
	}
}

struct HideTabBarIfKeyboardActive: ViewModifier {
	@ObservedObject var keyboard: Keyboard = .main

	func body(content: Content) -> some View {
		content.introspectTabBarController { (tabBarController) in
			tabBarController.tabBar.isHidden = keyboard.isShowing
		}
	}
}

struct IfKeyboardActive<Body: View>: ViewModifier {
	@ObservedObject var keyboard: Keyboard = .main
	let onActive: (_ content: Self.Content) -> Body
	let onInactive: (_ content: Self.Content) -> Body

	func body(content: Self.Content) -> some View {
		if keyboard.isShowing { return onActive(content) } else { return onInactive(content) }
	}
}
