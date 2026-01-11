import Foundation
import NoodlesDataModel

public final class Preview {
    @MainActor public static var language = PreviewLanguageSet()
    @MainActor public static var phrase = PreviewPhraseSet()
    
    public struct PreviewLanguageSet {
        public var en = Language(id: "en", title: "English", icon: "🇬🇧")
        public var zh = Language(id: "zh", title: "Chinese", icon: "🇨🇳")
    }
    
    public struct PreviewPhraseSet {
        
    }
}
