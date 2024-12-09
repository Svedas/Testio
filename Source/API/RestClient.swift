//
//  RestClient.swift
//  Testio
//
//  Created by Mantas Svedas on 04/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire
import Foundation

protocol RestClientProtocol {
    func authorize(credentials: LoginCredentials) async throws
    
    func executeRequest<Parameters: Encodable & Sendable, Response: Decodable>(
        components: [String],
        method: RestClientHTTPMethod,
        parameters: Parameters,
        headers: [String: String]?
    ) async throws -> Response
    
    func executeRequest<Response: Decodable>(
        components: [String],
        method: RestClientHTTPMethod,
        headers: [String: String]?
    ) async throws -> Response
}

final class RestClient: RestClientProtocol {
    enum Constant {
        static let baseURLString = "https://playground.nordsec.com/v1"
        
        static let authorizationPathComponents = ["tokens"]
        static let serverListPathComponents = ["servers"]
    }
    
    private static var oAuthInterceptor: OAuthInterceptor<OAuthToken>!
    
    private var session: Session
    
    init() {
        if Self.oAuthInterceptor == nil {
            Self.oAuthInterceptor = Self.makeOAuthInterceptor()
        }
        
        self.session = Self.makeSession()
    }
    
    static var baseURL: URL {
        get throws {
            guard let url = URL(string: Constant.baseURLString) else {
                throw RestClientError.incorrectURL(url: Constant.baseURLString)
            }
            
            return url
        }
    }
    
    func authorize(credentials: LoginCredentials) async throws {
        let grantType = OAuthGrantTypePassword(username: credentials.username, password: credentials.password)
        
        try await Self.oAuthInterceptor.processor.authorize(grantType: grantType)
    }
    
    // MARK: Encodable request
    
    func executeRequest<Parameters: Encodable & Sendable, Response: Decodable>(
        components: [String],
        method: RestClientHTTPMethod,
        parameters: Parameters,
        headers: [String: String]?
    ) async throws -> Response {
        let url = components.reduce(into: try Self.baseURL) { $0.append(component: $1) }
        let httpHeaders: HTTPHeaders? = if let headers {
            HTTPHeaders(headers.map { HTTPHeader(name: $0.key, value: $0.value) })
        } else {
            nil
        }
        
        let response = await session
            .request(
                url,
                method: method.alamofireHTTPMethod,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: httpHeaders
            )
            .validate()
            .serializingData()
            .response
        
        return try parseResponse(response)
    }
    
    func executeRequest<Response: Decodable>(
        components: [String],
        method: RestClientHTTPMethod,
        headers: [String: String]?
    ) async throws -> Response {
        let url = components.reduce(into: try Self.baseURL) { $0.append(component: $1) }
        let httpHeaders: HTTPHeaders? = if let headers {
            HTTPHeaders(headers.map { HTTPHeader(name: $0.key, value: $0.value) })
        } else {
            nil
        }
        
        let response = await session
            .request(
                url,
                method: method.alamofireHTTPMethod,
                parameters: nil,
                headers: httpHeaders
            )
            .validate()
            .serializingData()
            .response
        
        return try parseResponse(response)
    }
    
    func parseResponse<T: Decodable>(_ response: AFDataResponse<Data>) throws -> T {
        switch response.result {
        case .success(let data):
            try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw RestClientError.badRequest(error: error)
        }
    }
}

// MARK: - Session and OAuth creation

private extension RestClient {
    static func makeSession() -> Session {
        Session(interceptor: oAuthInterceptor)
    }
    
    static func makeOAuthInterceptor() -> OAuthInterceptor<OAuthToken>? {
        guard let configuration = makeOAuthConfiguration() else { return nil }
        
        return OAuthInterceptor(
            processor: OAuthProcessor(
                storage: OAuthStorage(),
                configuration: configuration,
                requestBuilder: OAuthRequestBuilder()
            )
        )
    }
    
    static func makeOAuthConfiguration() -> OAuthConfiguration? {
        do {
            let url = Constant.authorizationPathComponents.reduce(into: try baseURL) { $0.append(component: $1) }
            
            return OAuthConfiguration(
                authUrl: url,
                authSession: Session()
            )
        } catch {
            debugPrint("Failed to create OAuth configuration", error)
            return nil
        }
    }
}
