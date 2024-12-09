//
//  SwinjectUtility.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import CoreData
import Foundation
@preconcurrency import Swinject

struct SwinjectUtility {
    private static let container = Container()
    private static let resolver = container.synchronize()
    
    private init() {}
    
    @MainActor
    static func registerDependencies() {
        registerSharedDependencies()
        registerInstanceDependencies()
    }
    
    @discardableResult
    static func register<Service>(
        _ service: SwinjectService<Service>,
        factory: @escaping (Resolver) -> Service
    ) -> ServiceEntry<Service> {
        assert(Thread.isMainThread, "Registrations must be performed on a main thread")
        return container.register(Service.self, name: nil, factory: factory)
    }
    
    static func resolve<Service>(_ service: SwinjectService<Service>) -> Service {
        guard let resolved = resolver.resolve(Service.self, name: nil) else {
            fatalError("Could not resolve \(service)")
        }
        return resolved
    }
    
    static func removeAll() {
        container.removeAll()
    }
}

// MARK: - Private functionality

private extension SwinjectUtility {
    @MainActor
    static func registerSharedDependencies() {
        register(.authorizationManager) { _ in
            AuthorizationManager()
        }.inObjectScope(.container)
        
        register(.coreDataManager) { _ in
            CoreDataManager()
        }.inObjectScope(.container)
        
        register(.keychainManager) { _ in
            KeychainManager.sharedInstance
        }.inObjectScope(.container)
    }
    
    @MainActor
    static func registerInstanceDependencies() {
        register(.restClient) { _ in
            RestClient()
        }
        
        register(.managedObjectContext) { resolver in
            // swiftlint:disable:next force_unwrapping
            resolver.resolve(CoreDataManager.self)!.managedObjectContext
        }
    }
}
