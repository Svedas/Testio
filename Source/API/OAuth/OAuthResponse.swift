//
//  OAuthResponse.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

struct OAuthResponse: OAuthResponseProtocol {
    private enum CodingKeys: String, CodingKey {
        case rawToken = "token"
    }
    
    let rawToken: String
    
    var token: OAuthToken {
        OAuthToken(accessToken: rawToken)
    }
}
