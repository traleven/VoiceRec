import Foundation
import CoreText
import SwiftUI

extension Font {
    
    public struct Inter {
        private static let fontNames = [
            "Inter-Bold.ttf",
            "Inter-Medium.ttf",
            "Inter-Regular.ttf",
            "Inter-SemiBold.ttf",
            "InterDisplay-Bold.ttf",
            "InterDisplay-Medium.ttf",
            "InterDisplay-Regular.ttf",
            "InterDisplay-SemiBold.ttf",
            "InterVariable.ttf",
        ]
        
        public static func register() -> [String] {
            guard let fonts = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: nil) else {
                print("*** ERROR: ***")
                return []
            }
            return fonts.reduce(into: [], { result, font in
                if registerFont(font as CFURL) {
                    result.append(font.lastPathComponent)
                }
            })
        }
        
        private static func registerFont(_ url: CFURL) -> Bool {
            var errorRef: Unmanaged<CFError>? = nil
            if !CTFontManagerRegisterFontsForURL(url, .process, &errorRef) {
                print("*** ERROR: \(errorRef.debugDescription) ***")
                return false
            }
            return true
        }
    }
}
