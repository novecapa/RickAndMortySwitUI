//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

// MARK: CharactersUseCase
final class CharactersUseCase {

    let repository: CharactersRepositoryProtocol
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
}
// MARK: CharactersUseCaseProtocol
extension CharactersUseCase: CharactersUseCaseProtocol {
    func getCharacters(page: Int) async throws -> Characters {
        try await repository.getCharacters(page: page)
    }

    func searchCharacters(for this: String, page: Int) async throws -> Characters {
        try await repository.searchCharacters(for: this, page: page)
    }
}
