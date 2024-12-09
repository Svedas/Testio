//
//  OAuthGrantTypeProtocol.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

protocol OAuthGrantTypeProtocol {
    var grantName: String { get }
    
    var fields: [String: String] { get }
}
