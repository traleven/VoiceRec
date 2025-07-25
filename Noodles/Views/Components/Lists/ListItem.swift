//
//  ListItem.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI

struct ListItem<Title: StringProtocol>: View {
    @Environment(\.style) private var style
    
    enum Mode { case regular, recessed }

    var title: Title
    var avatar: Image? = nil
    var emoji: String? = nil
    var mode: Mode = .regular
    var content: Content? = nil
    
    var avatarColor: Color {
        if case .check(let binding) = content, binding.wrappedValue {
            return style.color.text.regular.selected
        }
        
        switch mode {
        case .regular: return style.color.icon.tertiary.foreground
        case .recessed: return style.color.icon.tertiary.foreground
        }
    }
    
    var textColor: Color {
        if case .check(let binding) = content, binding.wrappedValue {
            return style.color.text.regular.selected
        }
        switch mode {
        case .regular: return style.color.text.regular.primary
        case .recessed: return style.color.text.regular.secondary
        }
    }
    
    var isSearch: Bool {
        if case .search = content { return true } else { return false }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if !isSearch {
                HStack(alignment: .center, spacing: 12) {
                    if let avatar {
                        avatar
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .clipped()
                            .foregroundColor(avatarColor)
                            .background {
                                Circle()
                                    .foregroundColor(style.color.icon.tertiary.background)
                            }
                    }
                    
                    if let emoji, !emoji.isEmpty {
                        Text(emoji)
                            .font(style.font.body.label)
                            .foregroundColor(style.color.text.regular.primary)
                    }
                    
                    Text(title)
                        .font(style.font.body.label)
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    switch content {
                    case .icon(let image):
                        image
                            .foregroundColor(style.color.icon.tertiary.foreground)
                            .frame(width: 24, height: 24)
                    case .check(let binding):
                        Button(action: { withAnimation{ binding.wrappedValue = !binding.wrappedValue } }) {
                            Circle()
                                .overlay {
                                    if binding.wrappedValue {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(style.color.icon.accent.foreground)
                                    } else {
                                        Circle()
                                            .stroke(style.color.icon.tertiary.foreground, lineWidth: 1.11111)
                                    }
                                }
                                .foregroundStyle(binding.wrappedValue ? style.color.icon.accent.background : style.palette.transparent)
                                .padding(2)
                                .frame(width: 24, height: 24)
                        }
                    case .pill(let label):
                        PillButton(action: {}, label: label, role: .regular)
                    case .label(let label):
                        Text(label)
                            .font(style.font.body.body)
                            .foregroundColor(textColor)
                    case .toggle(let binding):
                        Toggle(title, isOn: binding)
                            .tint(style.color.icon.selected.foreground)
                            .labelsHidden()
                    case .slider(let binding, let format):
                        Text(binding.wrappedValue.formatted(format))
                            .font(style.font.body.body)
                            .foregroundColor(style.color.text.regular.primary)
                    case .search(_):
                        EmptyView()
                    case nil:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(height: 48, alignment: .leading)
                
                switch content {
                case .slider(let binding, _):
                    Slider(value: binding)
                        .tint(style.color.fill.button.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .leading)
                default:
                    EmptyView()
                }
            } else { // isSearch
                switch content {
                case .search(let binding):
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(style.color.text.regular.secondary)
                            .frame(width: 20, height: 20)
                        
                        TextField("Item label", text: binding, prompt: Text("Search")
                            .foregroundStyle(style.color.text.placeholder.light)
                        )
                        .font(style.font.body.label)
                        .foregroundColor(style.color.text.regular.secondary)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(height: 48, alignment: .leading)
                default:
                    EmptyView()
                }
            }
        }
    }
}

extension ListItem {
    enum Content {
        case icon(Image)
        case check(Binding<Bool>)
        case pill(String)
        case label(String)
        case toggle(Binding<Bool>)
        case slider(Binding<Float>, FloatingPointFormatStyle<Float>)
        case search(Binding<String>)
    }
}

#Preview {
    ScrollView(.vertical) {
        ListItem(title: "Item with emoji", emoji: "⭐️")
        ListItem(title: "Item with emoji & avatar", avatar: Image(systemName: "person.circle"), emoji: "⭐️")
        Divider()
        
        ListItem(title: "Item with icon content", content: .icon(Image(systemName: "square")))
        ListItem(title: "Item with icon content & avatar", avatar: Image(systemName: "person.circle"), content: .icon(Image(systemName: "square")))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .check(.constant(false)))
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .check(.constant(true)))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .pill("Tag"))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .label("Value"))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .toggle(.constant(false)))
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .toggle(.constant(true)))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .slider(.constant(0.1), .number))
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .slider(.constant(0.9), .number))
        Divider()
        
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .search(.constant("")))
        ListItem(title: "Item label", avatar: Image(systemName: "person.circle"), content: .search(.constant("Abc")))
    }
}
