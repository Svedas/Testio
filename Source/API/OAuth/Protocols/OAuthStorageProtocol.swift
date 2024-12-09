//
//  OAuthStorageProtocol.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

protocol OAuthStorageProtocol {
    associatedtype Token: OAuthTokenProtocol
    
    var token: Token? { get throws }
    func saveToken(_ token: Token) throws
    func deleteToken() throws
}
