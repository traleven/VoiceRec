//
//  PhraseListItem.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI

struct PhraseListItem<Title: StringProtocol, Subtitle: StringProtocol>: View {
    @Environment(\.style) private var style
    
    var title: Title
    var subtitle: Subtitle? = nil
    var action: Action
    var separator: Visibility = .visible
    
    @ViewBuilder
    var icon: some View {
        switch action {
        case .play(let action):
            Button(action: action) {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(style.color.icon.tertiary.background)
                    .overlay {
                        Image(systemName: "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 7, height: 8.23281)
                            .foregroundStyle(style.color.icon.tertiary.foreground)
                            .clipped()
                    }
            }
        case .record(let action):
            Button(action: action) {
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .overlay {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12.222, height: 12.222)
                            .foregroundStyle(style.color.icon.tertiary.foreground)
                            .clipped()
                    }
            }
        case .pause(let action):
            Button(action: action) {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(style.color.icon.accent.background)
                    .overlay {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 7, height: 9.42)
                            .foregroundStyle(style.color.icon.accent.foreground)
                            .clipped()
                    }
            }
        case .check(let binding):
            Button(action: { withAnimation { binding.wrappedValue.toggle() }}) {
                let checked = binding.wrappedValue
                Circle()
                    .background {
                        if !checked {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(style.color.icon.tertiary.foreground)
                        }
                    }
                    .frame(width: 20, height: 20)
                    .foregroundStyle(checked
                                     ? style.color.icon.accent.background
                                     : style.palette.transparent
                    )
                    .overlay {
                        if checked {
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 10, height: 8.33)
                                .foregroundStyle(style.color.icon.accent.foreground)
                                .clipped()
                        }
                    }
            }
        case .counter(let count):
            Text(count, format: .number)
                .font(style.font.body.labelSmall)
                .foregroundColor(style.color.text.regular.secondary)
                .frame(width: 20, alignment: .leading)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                icon
                    .padding(2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(style.font.body.labelLarge)
                        .foregroundColor(style.color.text.regular.primary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(style.font.body.bodySmall)
                            .foregroundColor(style.color.text.regular.secondary)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 20)
            .frame(alignment: .leading)
            
            if separator != .hidden {
                HSeparator()
            }
        }
        .padding(.horizontal, 16)
    }
}

extension PhraseListItem where Title == String, Subtitle == String {
    init(_ phrase: Phrase, for language: Language) {
        let entry = phrase.entry(for: language)
        self.init(
            title: entry.title,
            subtitle: phrase.sortIndex.formatted(),
            action: entry.audio != nil ? .play({}) : .record({})
        )
    }
}

extension PhraseListItem where Subtitle == String {
    init(title: Title, action: Action, separator: Visibility = .visible) {
        self.init(title: title, subtitle: nil, action: action, separator: separator)
    }
}

extension PhraseListItem {
    enum Action {
        case play(@MainActor () -> Void), record(@MainActor () -> Void), pause(@MainActor () -> Void)
        case check(Binding<Bool>)
        case counter(Int)
    }
}

#Preview {
    PhraseListItem(title: "Primary phrase", action: .play({}), separator: .hidden)
    PhraseListItem(title: "Primary phrase", action: .play({}), separator: .visible)
    PhraseListItem(title: "Primary phrase", subtitle: "Phrase secondary", action: .play({}))
    Divider()
    
    PhraseListItem(title: "Primary phrase (record)", action: .record({}), separator: .hidden)
    PhraseListItem(title: "Primary phrase (pause)", action: .pause({}), separator: .visible)
    
    PhraseListItem(title: "Primary phrase", action: .check(.constant(false)), separator: .hidden)
    PhraseListItem(title: "Primary phrase", action: .check(.constant(true)), separator: .visible)
    
    PhraseListItem(title: "Primary phrase", action: .counter(0), separator: .hidden)
    PhraseListItem(title: "Primary phrase", action: .counter(5), separator: .hidden)
    PhraseListItem(title: "Very long multiline primary phrase to test alignment", action: .counter(5), separator: .hidden)
    PhraseListItem(title: "Primary phrase", action: .counter(15), separator: .hidden)
}
