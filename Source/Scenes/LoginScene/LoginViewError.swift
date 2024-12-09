//
//  LoginViewError.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Foundation

enum LoginViewError: LocalizedError {
    case verificationFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .verificationFailed:
            "Verification Failed"
        case .unknown:
            "Unknown error occured"
        }
    }
    
    var errorDetails: String {
        switch self {
        case .verificationFailed:
            "Your username or password is incorrect"
        case .unknown:
            "Try something else :)"
        }
    }
}
