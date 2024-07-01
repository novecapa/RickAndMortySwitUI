//
//  CharactersRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int) async throws -> Characters
    func searchCharacters(for this: String, page: Int) async throws -> Characters
}
