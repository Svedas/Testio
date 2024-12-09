//
//  ServerListViewModelTests.swift
//  UnitTests
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

@testable import Testio
import XCTest
import Combine
import CoreData

@MainActor
final class ServerListViewModelTests: TestioTestCase {
    private var sut: ServerListViewModel!
    private var restClientMock: RestClientMock!
    private var managedObjectContext: NSManagedObjectContext!
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() async throws {
        try await super.setUp()
        
        sut = ServerListViewModel()
        restClientMock = SwinjectUtility.resolve(.restClient) as? RestClientMock
        managedObjectContext = SwinjectUtility.resolve(.managedObjectContext)
    }

    override func tearDown() async throws {
        sut = nil
        subscriptions.removeAll()
        
        try await super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_loadServerData_showsProgressView() async throws {
        // Arrange
        restClientMock._response = [ServerResponse(name: "Test", distance: 1337)]
        
        var result = [Bool]()
        let expectation = [false, true, false]
        
        sut.$showProgressView
            .collect(expectation.count)
            .sink { result = $0 }
            .store(in: &subscriptions)
        
        // Act
        try await sut.loadServerData()
        
        // Assert
        XCTAssertEqual(result, expectation)
    }
    
    func test_refreshServerData_updatesDataOnSuccess() async throws {
        // Arrange
        let server1 = Server(context: managedObjectContext)
        server1.name = "Test1"
        server1.distance = 100
        
        restClientMock._response = [ServerResponse(name: "Test2", distance: 1337)]
        
        XCTAssertEqual(sut.sortedServers.count, 0)
        
        // Act
        try await sut.refreshServerData()
        
        // Assert
        XCTAssertEqual(sut.sortedServers.count, 2)
    }
    
    func test_refreshServerData_keepsLocalDataOnFailure() async throws {
        // Arrange
        let server1 = Server(context: managedObjectContext)
        server1.name = "Test1"
        server1.distance = 100
        
        restClientMock._executeRequestError = RestClientMockError.fakeError
        
        XCTAssertEqual(sut.sortedServers.count, 0)
        
        // Act
        try? await sut.refreshServerData()
        
        // Assert
        XCTAssertEqual(sut.sortedServers.count, 1)
    }
    
    func test_changeSortType() async throws {
        // Arrange
        restClientMock._executeRequestError = RestClientMockError.fakeError
        
        let server1 = Server(context: managedObjectContext)
        server1.name = "Australia"
        server1.distance = 13440
        
        let server2 = Server(context: managedObjectContext)
        server2.name = "Brasil"
        server2.distance = 10490
        
        let server3 = Server(context: managedObjectContext)
        server3.name = "China"
        server3.distance = 6154
        
        // Act
        try? await sut.loadServerData()
        sut.changeSortType(to: .byDistance)
        
        // Assert
        let firstServerByDistance = sut.sortedServers.first
        XCTAssertEqual(firstServerByDistance?.name, server3.name)
        XCTAssertEqual(firstServerByDistance?.distance, Int(server3.distance))
        
        // Act
        try? await sut.loadServerData()
        sut.changeSortType(to: .alphabetically)
        
        // Assert
        let firstServerAlphabetically = sut.sortedServers.first
        XCTAssertEqual(firstServerAlphabetically?.name, server1.name)
        XCTAssertEqual(firstServerAlphabetically?.distance, Int(server1.distance))
    }

    func test_logout_publishesEvent() async throws {
        // Arrange
        let expectation = self.expectation(description: "Awaiting didRequestLogoutPublisher")
        sut.didRequestLogoutPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // Act
        sut.logout()
        
        // Assert
        await fulfillment(of: [expectation], timeout: 10)
    }
}
