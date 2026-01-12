//
//  LessonContentFragment.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDataModel
import NoodlesUIComponents

struct LessonContentFragment: View {
    @Environment(\.style) private var style
    @Environment(\.navigate) private var navigate

    var content: [String]
    
    var body: some View {
        if content.isEmpty {
            EmptyPageContent(
                style: style,
                title: "Add phrase",
                action: openNewLesson,
            )
        } else {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 8) {
                            // Body/Body Small
                            Text("\(content.count) phrases")
                              .font(Font.custom("Inter Variable", size: 15))
                              .multilineTextAlignment(.center)
                              .foregroundColor(style.color.text.regular.secondary)
                        }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(Array(content.indices), id: \.self) { index in
                            PhraseListItem(
                                style: style,
                                title: content[index],
                                action: .counter(index + 1),
                            )
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.leading, 16)
                .padding(.trailing, 0)
                .padding(.top, 0)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding(0)
            .frame(width: 393, height: 546, alignment: .top)
        }
    }
    
    func openNewLesson() {
        print("TODO: create a new lesson and open it in LessonDetails view")
    }
}

#Preview("Empty") {
    LessonContentFragment(content: [])
}

#Preview("Full") {
    LessonContentFragment(content: [
        "Hi, do you have majiang mian?",
        "Do you have with minced pork or only regular?",
        "Ok, one with pork please",
        "Oh by the way, no beansprouts cos I'm allergic, thanks",
        "Is water free?",
    ])
}
