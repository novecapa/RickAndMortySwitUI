//
//  CharacterDetailBuilder.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

final class CharacterDetailBuilder {
    func build(_ character: Character) -> CharacterDetailView {
        return CharacterDetailView(character)
    }
}
