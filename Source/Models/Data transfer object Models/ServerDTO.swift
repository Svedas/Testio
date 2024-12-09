//
//  TestServerDTO.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation

struct ServerDTO: Identifiable {
    let id = UUID().uuidString
    
    let name: String
    let distance: Int
}
