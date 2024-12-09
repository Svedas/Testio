//
//  RestClientMock.swift
//  UITests
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

@testable import Testio
import Foundation

enum RestClientMockError: Error {
    case fakeError
}

final class RestClientMock: RestClientProtocol {
    var _authorizeError: Error?
    
    var _executeRequestError: Error?
    var _response: Decodable?
    
    func authorize(credentials: Testio.LoginCredentials) async throws {
        if let _authorizeError {
            throw _authorizeError
        }
    }
    
    func executeRequest<Parameters, Response>(
        components: [String],
        method: Testio.RestClientHTTPMethod,
        parameters: Parameters,
        headers: [String : String]?
    ) async throws -> Response where Parameters : Encodable, Parameters : Sendable, Response : Decodable {
        if let _executeRequestError {
            throw _executeRequestError
        } else {
            return _response as! Response
        }
    }
    
    func executeRequest<Response>(
        components: [String],
        method: Testio.RestClientHTTPMethod,
        headers: [String : String]?
    ) async throws -> Response where Response : Decodable {
        if let _executeRequestError {
            throw _executeRequestError
        } else {
            return _response as! Response
        }
    }
}
