//
//  LoginView.swift
//  Testio
//
//  Created by Mantas Svedas on 04/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    private enum Constant {
        static let usernameTextFieldPlaceholder = "Username"
        static let passwordTextFieldPlaceholder = "Password"
        static let actionButtonPlaceholder = "Log in"
        static let alertButtonText = "OK"
        
        static let usernameTextFieldImageName = "person.crop.circle.fill"
        static let passwordTextFieldImageName = "lock.circle.fill"
        
        static let interactiveElementHeight: CGFloat = 40
    }
    
    private enum Field: Hashable {
        case username
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    @StateObject private var viewModel: LoginViewModel
    
    @State private var showAlert = false
    @State private var alertError: LoginViewError?
    
    init(viewModel: @autoclosure @escaping () -> LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            logoView
            
            usernameView
            passwordView
            loginButtonView
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Views {

private extension LoginView {
    var logoView: some View {
        Image(asset: TestioAsset.testioLogo)
            .frame(width: 186, height: 48)
            .padding(.bottom, 40)
    }
    
    var usernameView: some View {
        RoundedWithBackgroundHStack {
            Image(systemName: Constant.usernameTextFieldImageName)
                .padding(.leading)
            TextField(Constant.usernameTextFieldPlaceholder, text: $viewModel.credentials.username)
                .textInputAutocapitalization(.never)
                .textContentType(.username)
                .frame(height: Constant.interactiveElementHeight)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
        }
    }
    
    var passwordView: some View {
        RoundedWithBackgroundHStack {
            Image(systemName: Constant.passwordTextFieldImageName)
                .padding(.leading)
            SecureField(Constant.passwordTextFieldPlaceholder, text: $viewModel.credentials.password)
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .frame(height: Constant.interactiveElementHeight)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
        }
    }
    
    var loginButtonView: some View {
        Button {
            focusedField = nil
            Task {
                do {
                    try await viewModel.login()
                } catch {
                    alertError = error as? LoginViewError
                    showAlert = true
                }
            }
        } label: {
            Text(Constant.actionButtonPlaceholder)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.showProgressView)
        .alert(isPresented: $showAlert, error: alertError) { _ in
            Button(Constant.alertButtonText) {
                showAlert = false
            }
        } message: { error in
            Text(error.errorDetails)
        }
        .frame(height: Constant.interactiveElementHeight)
        .rounded()
    }
}

// MARK: - Preview

#Preview {
    LoginView(viewModel: LoginViewModel())
}
