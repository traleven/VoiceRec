//
//  ProfileView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 05.06.20.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
		VStack() {
			Section() {
				Image("profile_new")
					.clipShape(Circle())
					.scaledToFill()
				Text("Ivan Dolgushin")
					.font(.title)
					.foregroundColor(.blue)
				Text("idipster@gmail.com")
					.font(.footnote)
					.underline()
			}
			Form() {
				Section(header: Text("ABOUT")) {
					HStack() {
						Image("filter_themes_selected")
							.scaleEffect(0.5)
						Text("FROM")
							.font(.caption)
						Text("Odessa, Ukraine")
							.font(.body)
					}
					HStack() {
						Image("filter_themes_selected")
							.scaleEffect(0.5)
						Text("LIVES IN")
							.font(.caption)
						Text("Odessa, Ukraine")
							.font(.body)
					}
				}

				Section(header: Text("LANGUAGES")) {
					HStack() {
						Text("Russian").font(.body)
						Spacer()
						Text("Mother tongue").font(.caption)
						Spacer()
					}
					HStack() {
						Text("Ukrainian").font(.body)
						Spacer()
						Text("Mother tongue").font(.caption)
						Spacer()
					}
					HStack() {
						Text("English").font(.body)
						Spacer()
						Text("Fluent").font(.caption)
						Spacer()
						Text("BASE")
							.foregroundColor(.white)
							.padding(5.0)
							.background(Rectangle().foregroundColor(.blue))
					}
					HStack() {
						Text("Mandarin Chinese").font(.body)
						Spacer()
						Text("Newbie").font(.caption)
						Spacer()
						Text("TARGET")
							.foregroundColor(.white)
							.padding(5.0)
							.background(Rectangle().foregroundColor(.pink))
					}
				}

				Section(header: Text("PREFERENCES")) {
					HStack() {
						Text("Default sequence preset").font(.body)
						Spacer()
						Text("A B A B B")
							.font(.headline)
							.foregroundColor(.blue)
					}
				}
			}
			.clipShape(RoundedRectangle(cornerRadius: 25))
			.shadow(radius: 5)
		}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
