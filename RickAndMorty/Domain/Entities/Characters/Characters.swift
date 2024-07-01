//
//  Characters.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

struct Characters {
    let characters: [Character]
    let hasNextPage: Bool
}
extension Characters {
    var addNewPage: Int {
        hasNextPage ? 1 : 0
    }
}
