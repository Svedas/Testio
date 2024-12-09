//
//  ServerListView.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct ServerListView: View {
    private enum Constant {
        static let titleText = "Testio."
        static let filterButtonText = "Filter"
        static let logoutButtonText = "Logout"
        
        static let progressViewText = "Loading list"
        
        static let sortByDistanceText = "By distance"
        static let sortAlphabeticallyText = "Alphabetically"
        
        static let filterButtonImageName = "arrow.up.arrow.down"
        static let logoutButtonImageName = "rectangle.portrait.and.arrow.right"
    }
    
    @StateObject private var viewModel: ServerListViewModel
    
    @State private var isPresentingFilters: Bool = false
    
    init(viewModel: @autoclosure @escaping () -> ServerListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.showProgressView {
                progressView
            } else {
                serverListView
            }
        }
        .task {
            await viewModel.loadServerData()
        }
    }
}

// MARK: - Views {

private extension ServerListView {
    var progressView: some View {
        ProgressView {
            Text(Constant.progressViewText)
        }
        .progressViewStyle(.circular)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var serverListView: some View {
        List {
            Section {
                ForEach(viewModel.sortedServers) { server in
                    ServerListItem(server: server)
                }
            } header: {
                ServerListHeaderView()
            }
        }
        .listStyle(.grouped)
        .toolbar {
            filterToolbarItem
            logoutToolbarItem
        }
        .navigationTitle(Constant.titleText)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.refreshServerData()
        }
    }
    
    var filterToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                isPresentingFilters = true
            }, label: {
                HStack {
                    Image(systemName: Constant.filterButtonImageName)
                    Text(Constant.filterButtonText)
                }
            })
            .confirmationDialog(
                .emptyString,
                isPresented: $isPresentingFilters,
                titleVisibility: .hidden
            ) {
                Button(Constant.sortByDistanceText) {
                    viewModel.changeSortType(to: .byDistance)
                }
                Button(Constant.sortAlphabeticallyText) {
                    viewModel.changeSortType(to: .alphabetically)
                }
            }
        }
    }
    
    var logoutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                viewModel.logout()
            },
            label: {
                HStack {
                    Text(Constant.logoutButtonText)
                    Image(systemName: Constant.logoutButtonImageName)
                }
            })
        }
    }
}

// MARK: - Preview

#Preview {
    ServerListView(viewModel: ServerListViewModel())
}
