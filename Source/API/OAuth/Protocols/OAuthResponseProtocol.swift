//
//  OAuthResponseProtocol.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

protocol OAuthResponseProtocol: Decodable, Sendable {
    associatedtype Token: OAuthTokenProtocol
    
    var token: Token { get }
}
