//
//  LoginViewModel.swift
//  Testio
//
//  Created by Mantas Svedas on 04/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var credentials = LoginCredentials(username: "", password: "")
    @Published var showProgressView = false
    
    private let didFinishLoginSubject = PassthroughSubject<Void, Never>()
    var didFinishLoginPublisher: AnyPublisher<Void, Never> {
        didFinishLoginSubject.eraseToAnyPublisher()
    }
    
    func login() async throws {
        showProgressView = true
        // Fake delay for nicer UX
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        defer {
            showProgressView = false
        }
        
        let restClient = SwinjectUtility.resolve(.restClient)
        do {
            try await restClient.authorize(credentials: credentials)
            didFinishLoginSubject.send()
        } catch let error {
            let statusCode = error.asAFError?.responseCode
            
            if statusCode == 401 {
                throw LoginViewError.verificationFailed
            } else {
                throw LoginViewError.unknown
            }
        }
    }
}
