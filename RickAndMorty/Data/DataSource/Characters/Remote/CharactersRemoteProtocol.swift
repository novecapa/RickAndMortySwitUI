//
//  CharactersRemoteProtocol.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

protocol CharactersRemoteProtocol {
    func getCharacters(page: Int) async throws -> CharactersDTO
    func searchCharacters(for this: String, page: Int) async throws -> CharactersDTO
}
