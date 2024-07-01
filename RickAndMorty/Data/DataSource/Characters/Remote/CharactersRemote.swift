//
//  CharactersRemote.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

// MARK: CharactersRemote
final class CharactersRemote {

    private enum Constants {
        static let baseURL = "https://rickandmortyapi.com/api/"
        static let character = "character"
        static let page = "page"
        static let name = "name"
    }

    let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
}
// MARK: CharactersRemoteProtocol
extension CharactersRemote: CharactersRemoteProtocol {
    func getCharacters(page: Int) async throws -> CharactersDTO {
        let url = Constants.baseURL + Constants.character
        let queryParams = [
            Constants.page: page
        ]
        return try await networkClient.call(urlString: url,
                                            method: .get,
                                            queryParams: queryParams,
                                            of: CharactersDTO.self)
    }

    func searchCharacters(for this: String, page: Int) async throws -> CharactersDTO {
        let url = Constants.baseURL + Constants.character
        let queryParams: [String: Any] = [
            Constants.page: page,
            Constants.name: this
        ]
        return try await networkClient.call(urlString: url,
                                            method: .get,
                                            queryParams: queryParams,
                                            of: CharactersDTO.self)
    }
}
