//
//  PhraseAudiobar.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI

struct PhraseAudiobar: View {
    @Environment(\.style) private var style
    
    var content: [CGFloat]?
    var duration: Duration?
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            PhraseAudioPlayer(content: content, duration: duration)
            
            if content != nil {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .background(style.color.icon.tertiary.background)
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .mask(Circle())
                    .frame(width: 32, height: 32, alignment: .center)
            }
            
            Image(systemName: "ellipsis")
                .frame(width: 32, height: 32)
        }
        .frame(height: 40)
    }
}

#Preview {
    PhraseAudiobar(content: nil)
    PhraseAudiobar(content: Audiowaves.placeholder, duration: .minutes(3))

}
