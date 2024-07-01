//
//  CharacterListViewModelTest.swift
//  RickAndMortyTests
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import XCTest
@testable import RickAndMorty

final class CharacterListViewModelTest: XCTestCase {

    enum Constants {
        static let waitSec: CGFloat = 2.5
        static let searchString = "Rick Sanchez"
    }

    var urlSession: URLSessionTest!
    var utils: UtilsWithConnectionTest!
    var networkClient: NetworkClient!
    var remoteData: CharactersRemote!
    var database: CharactersDatabase!
    var remoteRepository: CharactersRepository!
    var useCase: CharactersUseCase!
    var viewModel: CharactersListViewModel!
    var view: CharactersListView!

    @MainActor
    override func setUp() {
        self.urlSession = URLSessionTest(statusCode: 200)
        self.networkClient = NetworkClient(urlSession: urlSession)
        self.remoteData = CharactersRemote(networkClient: networkClient)
        self.database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
        self.utils = UtilsWithConnectionTest()
        self.remoteRepository = CharactersRepository(remote: remoteData,
                                                     database: database,
                                                     utils: utils)
        self.useCase = CharactersUseCase(repository: remoteRepository)
        self.viewModel = CharactersListViewModel(useCase: useCase)
        self.view = CharactersListView(viewModel: viewModel)
    }

    override func tearDown() {
        urlSession = nil
        utils = nil
        networkClient = nil
        remoteData = nil
        database = nil
        remoteRepository = nil
        useCase = nil
        viewModel = nil
        view = nil
    }

    func test_viewmodel_fetch() {
        // When
        viewModel.fetchCharacters()

        // Then
        let expectation = XCTestExpectation(description: "Wait for it...")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertGreaterThan(self.viewModel.characters.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_view_model_search() {
        // When
        viewModel.searchText = Constants.searchString

        // Then
        let expectation = XCTestExpectation(description: "Wait for it...")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertGreaterThan(self.viewModel.characters.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_get_remote_characters_not_empty() async throws {
        do {
            // When
            let res = try await useCase.getCharacters(page: 0)

            // Then
            XCTAssertGreaterThan(res.characters.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func test_search_remote_characters_not_empty() async throws {
        do {
            // Given
            let urlSession = URLSessionTestSearch(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
            utils = UtilsWithConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)

            // When
            let res = try await useCase.searchCharacters(for: Constants.searchString,
                                                         page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 1)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func test_search_remote_characters_empty() async throws {
        do {
            // Given
            let urlSession = URLSessionTestEmpty(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
            utils = UtilsWithConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)

            // When
            let res = try await useCase.searchCharacters(for: "", page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func test_save_characters_in_databse() async throws {
        do {
            // Given
            let list = try await useCase.getCharacters(page: 0)
            database.saveCharacters(characters: list.characters)

            // When
            let dbList = try await database.getCharacters()

            // Then
            XCTAssertGreaterThan(dbList.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_from_databse_not_empty() async throws {
        do {
            // Given
            let list = try await useCase.getCharacters(page: 0)
            database.saveCharacters(characters: list.characters)

            // When
            let dbSearch = try database.searchCharacter(for: Constants.searchString)

            // Then
            XCTAssertGreaterThan(dbSearch.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_from_databse_empty() async throws {
        do {
            // Given
            let list = try await useCase.getCharacters(page: 1)
            database.saveCharacters(characters: list.characters)

            // When
            let dbSearch = try database.searchCharacter(for: "")

            // Then
            XCTAssertEqual(dbSearch.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor
    func test_delete_characters_from_databse() async throws {
        do {
            // Given
            let list = try await remoteRepository.getCharacters(page: 1)
            database.saveCharacters(characters: list.characters)

            // When
            try database.deleteAllCharacters()
            let dbList = try database.getCharacters()

            // Then
            XCTAssertEqual(dbList.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor
    func test_get_characters_status_400() {
        // Given
        let urlSession = URLSessionTest(statusCode: 400)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersListViewModel(useCase: useCase)

        // When
        viewModel.fetchCharacters()

        // Then
        let expectation = XCTestExpectation(description: "Wait for it...")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.characters.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    @MainActor
    func test_get_characters_status_500() {
        // Given
        let urlSession = URLSessionTest(statusCode: 500)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                database: database,
                                                utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersListViewModel(useCase: useCase)

        // When
        viewModel.fetchCharacters()

        // Then
        let expectation = XCTestExpectation(description: "Wait for it...")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.characters.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    @MainActor
    func test_get_characters_without_internet() {
        do {
            // Given
            let urlSession = URLSessionTest(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
            let utils = UtilsWithoutConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)
            viewModel = CharactersListViewModel(useCase: useCase)
            try database.deleteAllCharacters()

            // When
            viewModel.fetchCharacters()

            // Then
            let expectation = XCTestExpectation(description: "Wait for it...")
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
                XCTAssertEqual(self.viewModel.characters.count, 0)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: Constants.waitSec)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_without_internet() async throws {
        do {
            // Given
            let urlSession = URLSessionTest(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(dataManager: SwiftDataContainerTest.shared)
            let utils = UtilsWithoutConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)
            try database.deleteAllCharacters()

            // When
            let res = try await useCase.searchCharacters(for: Constants.searchString,
                                                         page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 0)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
