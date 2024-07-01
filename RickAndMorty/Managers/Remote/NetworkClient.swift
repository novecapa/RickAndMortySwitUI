//
//  NetworkClient.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {

    let urlSession: URLSessionProtocol
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func call<T>(urlString: String,
                 method: NetworkMethod,
                 queryParams: [String: Any]? = nil,
                 of type: T.Type) async throws -> T where T: Decodable {

        var urlComponents = URLComponents(string: urlString)
        // Query params
        if let queryParams {
            urlComponents?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        guard let url = urlComponents?.url else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        do {
            let (data, response) = try await urlSession.getDataFrom(request, type: T.self)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            Log.thisRequest(response, data: data, request: request)
            if (200..<300).contains(response.statusCode) {
                return try JSONDecoder().decode(T.self, from: data)
            } else if (400..<499).contains(response.statusCode) {
                throw NetworkError.notFound
            } else if (500..<504).contains(response.statusCode) {
                throw NetworkError.serverError
            } else {
                throw NetworkError.badResponse
            }
        } catch {
            throw NetworkError.badRequest
        }
    }
}
