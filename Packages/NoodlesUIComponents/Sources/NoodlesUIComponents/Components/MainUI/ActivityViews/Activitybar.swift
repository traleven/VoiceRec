//
//  Activitybar.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

final class Activitybar {
    private init() {}
    
    struct Multiselect: View {
        let style: Style

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                style.color.line.divider
                    .frame(height: 1)
                
                HStack(alignment: .center, spacing: 8) {
                    Text("1 selected")
                        .font(style.font.body.bodySmall)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(style.color.text.regular.primary)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .center, spacing: 10) {
                    SecondaryButton(style: style, action: {}, label: "Add to lesson", icon: "plus.circle")
                    SecondaryButton(style: style, action: {}, label: "Edit properties", icon: "square.and.pencil")
                    
                    Spacer()
                    
                    Image(systemName: "paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21.99363, height: 20.00141)
                        .foregroundStyle(style.color.icon.primary.foreground)
                        .frame(width: 32, height: 32, alignment: .center)
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 0)
            .padding(.top, 13)
            .padding(.bottom, 42)
        }
    }
    
    struct Button: View {
        let style: Style

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                style.color.line.divider
                    .frame(height: 1)
                
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    PrimaryButton(style: style, action: {}, label: "Done")
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 13)
            .padding(.bottom, 42)
            .frame(height: 121, alignment: .topLeading)
        }
    }
    
    struct ActivityList: View {
        let style: Style

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                style.color.line.divider
                    .frame(height: 1)
                
                HStack(alignment: .center, spacing: 10) {
                    SecondaryButton(style: style, action: {}, label: "Copy link", icon: "link")
                    SecondaryButton(style: style, action: {}, label: "Share to", icon: "square.and.arrow.up")
                    SecondaryButton(style: style, action: {}, label: "WhatsApp", icon: "bubble", role: .whatsApp)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
            .padding(.top, 13)
            .padding(.bottom, 42)
            .frame(height: 121, alignment: .topLeading)
        }
    }
}

#Preview {
    Activitybar.Multiselect(style: .standard)
    Activitybar.Button(style: .standard)
    Activitybar.ActivityList(style: .standard)
}
