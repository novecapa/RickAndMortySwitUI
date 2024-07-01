//
//  Location.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

struct Location {
    let name: String
    let url: String
}
extension Location {
    var toSD: SDLocation {
        SDLocation(name: name, url: url)
    }
}
