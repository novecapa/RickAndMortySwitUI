//
//  UtilsTest.swift
//  RickAndMortyTests
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

@testable import RickAndMorty

final class UtilsWithConnectionTest: UtilsProtocol {
    var existsConnection: Bool {
        true
    }
}

final class UtilsWithoutConnectionTest: UtilsProtocol {
    var existsConnection: Bool {
        false
    }
}
