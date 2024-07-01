//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import SwiftUI

struct CharacterDetailView: View {

    enum Constants {
        static let circleDiam: CGFloat = 20
        static let fadeDuration: CGFloat = 0.25
        static let fontSize: CGFloat = 14
        static let paddingSize: CGFloat = 6
    }

    let character: Character
    init(_ character: Character) {
        self.character = character
    }

    var body: some View {
        VStack(alignment: .leading, content: {
            AsyncImageLoader(url: character.imageUrl)
                .scaledToFit()
                .background(.black)
            VStack(alignment: .leading, content: {
                HStack {
                    Circle()
                        .frame(width: Constants.circleDiam,
                               height: Constants.circleDiam,
                               alignment: .leading)
                        .foregroundColor(character.statusColor)
                    Text(character.status)
                        .lineLimit(1)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                Text(character.name)
                    .lineLimit(1)
                    .font(.title)
                    .foregroundColor(.white)
                if !character.type.isEmpty {
                    Text(character.type)
                        .lineLimit(1)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                if !character.species.isEmpty {
                    Text(character.species)
                        .lineLimit(2)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                Text(character.gender)
                    .lineLimit(1)
                    .font(.title2)
                    .foregroundColor(.white)
                Text(character.appearsOn)
                    .lineLimit(1)
                    .font(.title2)
                    .foregroundColor(.white)
            })
            .padding(.horizontal, Constants.paddingSize)
        })
        .padding()
        .background()
    }
}

#Preview {
    CharacterDetailBuilder().build(.mock)
}
