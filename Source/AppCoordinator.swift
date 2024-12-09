//
//  AppCoordinator.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    enum RootView: Hashable {
        case login
        case serverList
    }
    
    @Published private var rootView: RootView
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        rootView = SwinjectUtility.resolve(.authorizationManager).isAuthorized ? .serverList : .login
    }
    
    @ViewBuilder
    func buildView() -> some View {
        switch rootView {
        case .login:
            loginView()
        case .serverList:
            serverListView()
        }
    }
}

// MARK: - Root views {

private extension AppCoordinator {
    private func loginView() -> some View {
        let viewModel = LoginViewModel()
        
        viewModel.didFinishLoginPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.transition(to: .serverList)
            }
            .store(in: &subscriptions)
        
        return LoginView(viewModel: viewModel)
    }
    
    private func serverListView() -> some View {
        let viewModel = ServerListViewModel()
        
        viewModel.didRequestLogoutPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                
                try? SwinjectUtility.resolve(.authorizationManager).deleteAccessToken()
                
                transition(to: .login)
            }
            .store(in: &subscriptions)
        
        return ServerListView(viewModel: viewModel)
    }
}

// MARK: - Private functionality

private extension AppCoordinator {
    func transition(to view: RootView) {
        switch view {
        case .login:
            withAnimation(.smooth) {
                rootView = view
            }
        case .serverList:
            rootView = view
        }
    }
}
