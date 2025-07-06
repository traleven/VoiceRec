//
//  ActivitySheet.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI

struct ActivitySheet: View {
    @Environment(\.style) private var style

    var items: [String]
    
    @State private var searchText: String = ""
    @State private var selection: Set<String> = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Searchbar(text: $searchText)
            
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Item(title: item, isSelected: selection(for: item))
                }
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            if selection.isEmpty {
                Activitybar.ActivityList()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else {
                Activitybar.Button()
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .background(.white)
        .cornerRadius(30)
    }
    
    func selection(for item: String) -> Binding<Bool> {
        .init(get: {
            selection.contains(item)
        }, set: {
            if $0 { selection.insert(item) }
            else { selection.remove(item) }
        })
    }
    
    struct Item<Title: StringProtocol>: View {
        @Environment(\.style) private var style
        
        var title: Title
        @Binding var isSelected: Bool

        var body: some View {
            HStack(alignment: .center, spacing: 12) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 30, height: 30)
                    .background(
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .foregroundColor(isSelected ? style.color.text.regular.selected : style.color.text.regular.primary)
                    )
                    .cornerRadius(30)
                
                Text(title)
                    .font(style.font.body.label)
                    .foregroundColor(isSelected ? style.color.text.regular.selected : style.color.text.regular.primary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Button(action: { withAnimation{ self.isSelected.toggle() } }) {
                    Circle()
                        .overlay {
                            if isSelected {
                                Image(systemName: isSelected ? "checkmark" : "")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(style.color.icon.accent.foreground)
                            } else {
                                Circle()
                                    .stroke(style.color.icon.tertiary.foreground, lineWidth: 1.11111)
                            }
                        }
                        .foregroundStyle(isSelected ? style.color.icon.accent.background : style.palette.transparent)
                        .padding(2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
        }
    }
}

#Preview {
    ActivitySheet(items: ["Chris Peng", "Andrew Lin", "Susie Sha", "Vivian Law", "Ivan Dolgushin", "Ryan Wilke"])
}
