//
//  AuthorizationManager.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation
import SwiftUI

struct AuthorizationManager {
    private enum Constant {
        static let accessTokenKey = "accessTokenKey"
    }
    
    var isAuthorized: Bool {
        let token = try? getAccessToken()
        
        return token != nil
    }
    
    func getAccessToken() throws -> String? {
        guard
            let accessToken = try SwinjectUtility.resolve(.keychainManager).password(forKey: Constant.accessTokenKey)
        else {
            return nil
        }
        
        return accessToken
    }
    
    func saveAccessToken(_ accessToken: String) throws {
        try SwinjectUtility.resolve(.keychainManager).setPassword(accessToken, key: Constant.accessTokenKey)
    }
    
    func deleteAccessToken() throws {
        try SwinjectUtility.resolve(.keychainManager).removePassword(forKey: Constant.accessTokenKey)
    }
}
