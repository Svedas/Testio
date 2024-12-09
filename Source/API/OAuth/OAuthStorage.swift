//
//  OAuthStorage.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

struct OAuthStorage: OAuthStorageProtocol {
    var token: OAuthToken? {
        get throws {
            guard
                let accessToken = try SwinjectUtility.resolve(.authorizationManager).getAccessToken()
            else {
                return nil
            }
            
            return OAuthToken(accessToken: accessToken)
        }
    }
    
    func saveToken(_ token: OAuthToken) throws {
        try SwinjectUtility.resolve(.authorizationManager).saveAccessToken(token.accessToken)
    }
    
    func deleteToken() throws {
        try SwinjectUtility.resolve(.authorizationManager).deleteAccessToken()
    }
}
