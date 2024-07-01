//
//  NetworkClientProtocol.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

protocol NetworkClientProtocol {
    func call<T: Decodable>(urlString: String,
                            method: NetworkMethod,
                            queryParams: [String: Any]?,
                            of type: T.Type) async throws -> T
}
