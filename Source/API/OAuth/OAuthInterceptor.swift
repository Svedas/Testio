//
//  OAuthInterceptor.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire
import Foundation

private enum Constant {
    static let maxRetries = 1
}

struct OAuthInterceptor<Token: OAuthTokenProtocol>: RequestInterceptor, Sendable {
    let processor: OAuthProcessor<Token>
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        Task {
            do {
                let token = try await processor.getToken()
                addAccessTokenToRequest(urlRequest, token: token, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < Constant.maxRetries else {
            completion(.doNotRetry)
            return
        }
        
        completion(.retry)
    }
}

// MARK: - Private functionality

private extension OAuthInterceptor {
    func addAccessTokenToRequest(
        _ urlRequest: URLRequest,
        token: Token,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        let bearerField = HTTPHeader.authorization(bearerToken: token.accessToken)
        request.setValue(bearerField.value, forHTTPHeaderField: bearerField.name)
        
        completion(.success(request))
    }
}
