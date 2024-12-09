//
//  OAuthProcessor.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire
import Foundation

actor OAuthProcessor<Token: OAuthTokenProtocol> {
    private let storage: Token.Storage
    let configuration: OAuthConfiguration
    private let requestBuilder: OAuthRequestBuilderProtocol
    
    private var lastToken: Token?
    private var tokenTask: Task<Token, Error>?
    
    init(
        storage: Token.Storage,
        configuration: OAuthConfiguration,
        requestBuilder: OAuthRequestBuilder
    ) {
        self.storage = storage
        self.configuration = configuration
        self.requestBuilder = requestBuilder
        
        do {
            lastToken = try storage.token
        } catch {
            debugPrint("Failed to get token from storage", error)
        }
    }
    
    func getToken(forceRefresh: Bool = false) async throws -> Token {
        guard let lastToken else {
            throw OAuthError.noTokenFound
        }
        
        if let tokenTask {
            return try await tokenTask.value
        } else {
            return lastToken
        }
    }
    
    @discardableResult
    func authorize(grantType: OAuthGrantTypeProtocol) async throws -> Token {
        if let tokenTask {
            return try await tokenTask.value
        }
        
        let tokenTask = Task {
            try await getAccessToken(grantType: grantType)
        }
        
        do {
            debugPrint("Will get access token with grant type: \(grantType.grantName)")
            
            self.tokenTask = tokenTask
            let newToken = try await tokenTask.value
            self.tokenTask = nil
            
            try persistToken(newToken)
            
            debugPrint("Successfully acquired access token")
            
            return newToken
        } catch {
            self.tokenTask = nil
            throw error
        }
    }
    
    func reset() {
        tokenTask?.cancel()
        tokenTask = nil
        deleteCurrentToken()
    }
}

// MARK: - Private functionality

private extension OAuthProcessor {
    func getAccessToken(grantType: OAuthGrantTypeProtocol) async throws -> Token {
        do {
            let response = await requestBuilder.buildRequest(grantType: grantType, configuration: configuration)
                .validate()
                .serializingDecodable(Token.Response.self)
                .response
            
            switch response.result {
            case .success(let tokenResponse):
                return tokenResponse.token
            case .failure(let error):
                debugPrint("Access token failure object", response)
                throw error
            }
        } catch let error {
            debugPrint("Failed to get access token", error)
            
            throw error
        }
    }
    
    func persistToken(_ token: Token) throws {
        do {
            try storage.saveToken(token)
            lastToken = token
        } catch {
            debugPrint("Failed to persist token to storage", error)
            throw OAuthError.failedToPersistToken
        }
    }
    
    func deleteCurrentToken() {
        lastToken = nil
        do {
            try storage.deleteToken()
        } catch {
            debugPrint("Failed to delete token from storage", error)
        }
    }
}
