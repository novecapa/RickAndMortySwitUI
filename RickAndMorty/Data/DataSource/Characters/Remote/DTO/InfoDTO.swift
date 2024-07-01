//
//  InfoDTO.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

// MARK: - InfoDTO
struct InfoDTO: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
extension InfoDTO {
    var hasNextPage: Bool {
        guard let nextPage = next else {
            return false
        }
        return !nextPage.isEmpty ? true : false
    }
}
