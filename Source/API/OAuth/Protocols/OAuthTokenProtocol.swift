//
//  OAuthTokenProtocol.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

protocol OAuthTokenProtocol: Sendable {
    associatedtype Storage: OAuthStorageProtocol where Storage.Token == Self
    associatedtype Response: OAuthResponseProtocol where Response.Token == Self
    
    var accessToken: String { get }
}
