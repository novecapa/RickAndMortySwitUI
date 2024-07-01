//
//  SwiftDataClient.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
import SwiftData

final class SwiftDataContainer: SwiftDataContainerProtocol {

    static let shared: SwiftDataContainer = SwiftDataContainer()

    private init() {}

    @MainActor
    var container: ModelContainer = getModelContainer(inMemory: false)

    @MainActor
    static func getModelContainer(inMemory: Bool) -> ModelContainer {
        do {
            let container = try ModelContainer(for: SDCharacter.self, SDLocation.self,
                                               configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
