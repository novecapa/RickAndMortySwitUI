//
//  CharactersDatabase.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
import SwiftData

// MARK: CharactersDatabase
final class CharactersDatabase {

    let dataManager: SwiftDataContainerProtocol
    init(dataManager: SwiftDataContainerProtocol) {
        self.dataManager = dataManager
    }
}
// MARK: CharactersDatabaseProtocol
extension CharactersDatabase: CharactersDatabaseProtocol {
    @MainActor
    func getCharacters() throws -> [SDCharacter] {
        let fetchDescriptor = FetchDescriptor<SDCharacter>(predicate: nil,
                                                           sortBy: [SortDescriptor<SDCharacter>(\.id)])
        do {
            return try dataManager.container.mainContext.fetch(fetchDescriptor)
        } catch {
            throw SwiftDataError.errorFetch
        }
    }

    @MainActor
    func searchCharacter(for name: String) throws -> [SDCharacter] {
        let fetchDescriptor = FetchDescriptor<SDCharacter>(predicate: #Predicate {
            $0.name.localizedStandardContains(name)
        }, sortBy: [SortDescriptor<SDCharacter>(\.id)])
        do {
            return try dataManager.container.mainContext.fetch(fetchDescriptor)
        } catch {
            throw SwiftDataError.errorSearch
        }
    }

    func saveCharacters(characters: [Character]) {
        Task { @MainActor in
            characters.forEach {
                dataManager.container.mainContext.insert($0.toSD)
            }
        }
    }

    @MainActor
    func deleteAllCharacters() throws {
        do {
            let list = try getCharacters()
            list.forEach {
                dataManager.container.mainContext.delete($0)
            }
            try dataManager.container.mainContext.save()
        } catch {
            throw SwiftDataError.errorDelete
        }
    }
}
