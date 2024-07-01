//
//  Character.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
import SwiftUI

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: Location
    let episode: [String]

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status
    }
}
extension Character {
    var imageUrl: URL? {
        URL(string: image)
    }

    var statusColor: Color {
        switch status.lowercased() {
        case "dead":
            return .red
        case "alive":
            return .green
        default:
            return .yellow
        }
    }

    var appearsOn: String {
        "\("Appears on".localized()) \(episode.count) \("episode(s)".localized())"
    }
}
extension Character {
    var toSD: SDCharacter {
        SDCharacter(id: id,
                    name: name,
                    status: status,
                    species: species,
                    type: type,
                    genger: gender,
                    image: image,
                    location: location.toSD,
                    episode: episode)
    }
}
// MARK: Mock values
extension Character {
    static let mock: Character = Character(id: 1,
                                           name: "Name",
                                           status: "alive",
                                           species: "Specie",
                                           type: "Type",
                                           gender: "Gender",
                                           image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                           location: Location(name: "Location", url: "URL..."),
                                           episode: ["1", "2", "3"])
}
