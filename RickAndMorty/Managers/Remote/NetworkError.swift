//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case serverError
    case notFound
    case badResponse
    case decodeError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "There is nothing here. Please, search with another name".localized()
        default:
            return self.localizedDescription
        }
    }
}
