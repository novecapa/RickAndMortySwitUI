//
//  SDLocation.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
import SwiftData

@Model
class SDLocation {
    var name: String
    var url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
extension SDLocation {
    var toEntity: Location {
        Location(name: name, url: url)
    }
}
