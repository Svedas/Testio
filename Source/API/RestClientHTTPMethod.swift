//
//  RestClientHTTPMethod.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire

enum RestClientHTTPMethod: Int {
    case get
    case post
    case put
    case patch
    case delete
    
    var alamofireHTTPMethod: HTTPMethod {
        switch self {
        case .get:
            .get
        case .post:
            .post
        case .put:
            .put
        case .patch:
            .patch
        case .delete:
            .delete
        }
    }
}
