//
//  SwinjectService.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import CoreData

struct SwinjectService<Service> {
}

extension SwinjectService {
    static var authorizationManager: SwinjectService<AuthorizationManager> { .init() }
    static var coreDataManager: SwinjectService<CoreDataManager> { .init() }
    static var restClient: SwinjectService<RestClientProtocol> { .init() }
    static var keychainManager: SwinjectService<KeychainManager> { .init() }
    static var managedObjectContext: SwinjectService<NSManagedObjectContext> { .init() }
}
