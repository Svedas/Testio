//
//  KeychainManager.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation
import KeychainAccess

final class KeychainManager {    
    @MainActor static let sharedInstance = KeychainManager()
    
    private let keychain: Keychain
    
    private init() {
        keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "").accessibility(.afterFirstUnlock)
    }
    
    // MARK: - Password getting & setting interface
    
    func password(forKey key: String) throws -> String? {
        try keychain.get(key)
    }
    
    func setPassword(_ value: String?, key: String) throws {
        if let value = value {
            try keychain.set(value, key: key)
        } else {
            try removePassword(forKey: key)
        }
    }
    
    func removePassword(forKey key: String) throws {
        try keychain.remove(key)
    }
    
    func removeAllPasswords() throws {
        try keychain.removeAll()
    }
}
