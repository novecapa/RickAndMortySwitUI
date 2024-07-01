//
//  URLSessionTestEmpty.swift
//  RickAndMortyTests
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation
@testable import RickAndMorty

final class URLSessionTestEmpty: URLSessionProtocol {

    let statusCode: Int
    init(statusCode: Int) {
        self.statusCode = statusCode
    }

    func getDataFrom<T>(_ request: URLRequest,
                        type: T.Type) async throws -> (Data, URLResponse) where T: Decodable {

        if let url = Bundle.main.url(forResource: "CharacterEmptyDTO",
                                     withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                guard let urlRequest = request.url else {
                    throw NetworkError.badRequest
                }
                let response = HTTPURLResponse(url: urlRequest,
                                               statusCode: statusCode,
                                               httpVersion: "HTTP/1.1",
                                               headerFields: nil)
                return (data, response ?? URLResponse())
            } catch {
                throw NetworkError.decodeError
            }
        } else {
            throw NetworkError.badURL
        }
    }
}
