//
//  LoginViewModelTests.swift
//  UITests
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

@testable import Testio
import XCTest
import Combine

@MainActor
final class LoginViewModelTests: TestioTestCase {
    private var sut: LoginViewModel!
    private var restClientMock: RestClientMock!
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() async throws {
        try await super.setUp()
        
        sut = LoginViewModel()
        restClientMock = SwinjectUtility.resolve(.restClient) as? RestClientMock
    }

    override func tearDown() async throws {
        sut = nil
        subscriptions.removeAll()
        
        try await super.tearDown()
    }
    
    // MARK: - Tests

    func test_login_whenLoginFlowSucceeds_publishesEvent() async throws {
        // Arrange
        let expectation = self.expectation(description: "Awaiting didFinishLoginPublisher")
        sut.didFinishLoginPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // Act
        try await sut.login()
        
        // Assert
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func test_login_whenLoginFlowFails_throwsError() async throws {
        // Arrange
        restClientMock._authorizeError = RestClientMockError.fakeError
        
        var wasDidFinishLoginPublisherCalled = false
        sut.didFinishLoginPublisher
            .sink { _ in
                wasDidFinishLoginPublisherCalled = true
            }
            .store(in: &subscriptions)
        
        // Act
        do {
            try await sut.login()
            XCTFail("Error must be thrown")
        } catch {
            XCTAssert(true)
        }
        
        // Assert
        XCTAssertEqual(wasDidFinishLoginPublisherCalled, false)
    }
}
