//
//  ActivitySheet.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

struct ActivitySheet: View {
    @Environment(\.style) private var style

    var items: [String]
    
    @State private var searchText: String = ""
    @State private var selection: Set<String> = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Searchbar(text: $searchText)
            
            //LazyVStack(alignment: .leading, spacing: 0) {
            PlainList {
                ForEach(items, id: \.self) { item in
                    ListItem(title: item, avatar: Image(systemName: "person.circle"), content: .check(selection(for: item)))
                }
            }
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
}

#Preview {
    ActivitySheet(items: ["Chris Peng", "Andrew Lin", "Susie Sha", "Vivian Law", "Ivan Dolgushin", "Ryan Wilke"])
}
