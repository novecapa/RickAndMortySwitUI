//
//  CharactersListBuilder.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

final class CharactersListBuilder {
    func build() -> CharactersListView {
        let networkClient = NetworkClient(urlSession: URLSession.shared)
        let remoteDataSource = CharactersRemote(networkClient: networkClient)
        let databaseSource = CharactersDatabase(dataManager: SwiftDataContainer.shared)
        let repository = CharactersRepository(remote: remoteDataSource, database: databaseSource)
        let useCase = CharactersUseCase(repository: repository)
        let viewModel = CharactersListViewModel(useCase: useCase)
        let view = CharactersListView(viewModel: viewModel)
        return view
    }
}
