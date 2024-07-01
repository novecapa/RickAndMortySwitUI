//
//  HUDView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import SwiftUI

struct HUDView: View {

    enum Constants {
        static let cornerRadius: CGFloat = 8
        static let frameLoading: CGFloat = 120
    }

    let message: String
    init(message: String = "Loading...") {
        self.message = message
    }

    var body: some View {
        VStack {
            HUDView()
                .tint(.green)
            Text(message)
                .padding(.top)
        }
        .frame(width: Constants.frameLoading,
               height: Constants.frameLoading)
        .background(.black)
        .cornerRadius(Constants.cornerRadius)
    }
}

#Preview {
    HUDView()
}
