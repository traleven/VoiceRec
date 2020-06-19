//
//  LoadingView.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 18.06.20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("Welcome\nto Noodles!")
			.font(.largeTitle)
			.multilineTextAlignment(.center)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
