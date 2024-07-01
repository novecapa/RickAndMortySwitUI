//
//  CharactersDatabaseProtocol.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

protocol CharactersDatabaseProtocol {
    func getCharacters() throws -> [SDCharacter]
    func searchCharacter(for name: String) throws -> [SDCharacter]
    func saveCharacters(characters: [Character])
    func deleteAllCharacters() throws
}
