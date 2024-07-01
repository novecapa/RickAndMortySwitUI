//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 16/6/24.
//

import SwiftUI

struct CharacterCell: View {

    enum Constants {
        static let circleDiam: CGFloat = 20
        static let fontSize: CGFloat = 14
        static let paddingSize: CGFloat = 6
        static let defaultSize: CGFloat = 120
    }

    let character: Character
    let frameSize: CGFloat
    init(_ character: Character,
         frameSize: CGFloat = Constants.defaultSize) {
        self.character = character
        self.frameSize = frameSize
    }

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImageLoader(url: character.imageUrl)
                .frame(width: frameSize, height: frameSize)
                .scaledToFit()
                .background(.black)
            HStack {
                Circle()
                    .frame(width: Constants.circleDiam,
                           height: Constants.circleDiam,
                           alignment: .leading)
                    .foregroundColor(character.statusColor)
                Text(character.name)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .font(.system(size: Constants.fontSize))
                    .foregroundColor(.white)
            }
            .frame(alignment: .leading)
            .padding(.horizontal, Constants.paddingSize)
        }
        .padding(.bottom, Constants.paddingSize)
        .background(.black)
    }
}

#Preview {
    CharacterCell(.mock)
}
