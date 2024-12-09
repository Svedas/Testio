//
//  ServerListResponse.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation

typealias ServerListResponse = [ServerResponse]

struct ServerResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
    
    let name: String
    let distance: Int
}
