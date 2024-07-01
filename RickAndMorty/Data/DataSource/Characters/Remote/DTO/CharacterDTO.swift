//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

// MARK: - CharacterDTO
struct CharacterDTO: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: LocationDTO
    let episode: [String]
}
extension CharacterDTO {
    var toEntity: Character {
        Character(id: id,
                  name: name,
                  status: status,
                  species: species,
                  type: type,
                  gender: gender,
                  image: image,
                  location: location.toEntity,
                  episode: episode.map { $0 })
    }
}
