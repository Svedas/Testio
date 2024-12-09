//
//  OAuthGrantTypePassword.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

struct OAuthGrantTypePassword: OAuthGrantTypeProtocol {
    let username: String
    let password: String
    
    var grantName: String {
        "password"
    }
    
    var fields: [String: String] {
        [
            "username": username,
            grantName: password
        ]
    }
}
