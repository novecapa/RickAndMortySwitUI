//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
import SwiftUI

// MARK: CharactersRepository
final class CharactersRepository {

    let remote: CharactersRemoteProtocol
    let database: CharactersDatabaseProtocol
    let utils: UtilsProtocol
    init(remote: CharactersRemoteProtocol,
         database: CharactersDatabaseProtocol,
         utils: UtilsProtocol = Utils()) {
        self.remote = remote
        self.database = database
        self.utils = utils
    }

    private func convertToEntity(sdCharacters: [SDCharacter]) -> Characters {
        Characters(characters: sdCharacters.map { $0.toEntity }, hasNextPage: false)
    }
}
// MARK: CharactersRepositoryProtocol
extension CharactersRepository: CharactersRepositoryProtocol {
    func getCharacters(page: Int) async throws -> Characters {
        if page == 1 && !utils.existsConnection {
            let sdList = try database.getCharacters()
            return convertToEntity(sdCharacters: sdList)
        }
        let chList = try await remote.getCharacters(page: page).toEntity

        // SwiftData persistance
        database.saveCharacters(characters: chList.characters)

        return chList
    }

    func searchCharacters(for this: String, page: Int) async throws -> Characters {
        if !utils.existsConnection {
            let sdList = try database.searchCharacter(for: this)
            return convertToEntity(sdCharacters: sdList)
        }
        let chList = try await remote.searchCharacters(for: this, page: page).toEntity

        // SwiftData persistance
        database.saveCharacters(characters: chList.characters)

        return chList
    }
}
