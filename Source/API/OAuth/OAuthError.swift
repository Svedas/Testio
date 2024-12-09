//
//  OAuthError.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

enum OAuthError: Error {
    case unauthorized
    case noTokenFound
    case failedToPersistToken
}
