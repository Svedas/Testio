//
//  OAuthToken.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

struct OAuthToken: OAuthTokenProtocol {
    typealias Storage = OAuthStorage
    typealias Response = OAuthResponse
    
    let accessToken: String
}
