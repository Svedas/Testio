//
//  ServerListViewError.swift
//  Testio
//
//  Created by Mantas Svedas on 09/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation

enum ServerListViewError: LocalizedError {
    case serverFetchFailed
    
    var errorDescription: String? {
        switch self {
        case .serverFetchFailed:
            "Server fetch failed"
        }
    }
    
    var errorDetails: String {
        switch self {
        case .serverFetchFailed:
            "Check your internet connection"
        }
    }
}
