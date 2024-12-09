//
//  TestioTestCase.swift
//  UnitTests
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

@testable import Testio
import XCTest

class TestioTestCase: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        await registerTestDependencies()
    }

    override func tearDown() async throws {
        cleanTestDependencies()
        try await super.tearDown()
    }
    
    @MainActor
    func registerTestDependencies() async {
        SwinjectUtility.register(.restClient) { _ in
            RestClientMock()
        }.inObjectScope(.container)
        
        SwinjectUtility.register(.coreDataManager) { _ in
            CoreDataManager()
        }.inObjectScope(.container)
        
        SwinjectUtility.register(.managedObjectContext) { resolver in
            // swiftlint:disable:next force_unwrapping
            resolver.resolve(CoreDataManager.self)!.testManagedObjectContext
        }.inObjectScope(.container)
    }
    
    func cleanTestDependencies() {
        SwinjectUtility.removeAll()
    }
}
