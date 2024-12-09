//
//  ServerListViewModel.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class ServerListViewModel: ObservableObject {
    enum SortType {
        case byDistance
        case alphabetically
    }
    
    @Published var showProgressView = false
    @Published private var sortType: SortType = .byDistance
    @Published private var servers = [ServerDTO]()
    
    var sortedServers: [ServerDTO] {
        switch sortType {
        case .byDistance:
            servers.sorted { $0.distance < $1.distance }
        case .alphabetically:
            servers.sorted { $0.name < $1.name }
        }
    }
    
    private let didRequestLogoutSubject = PassthroughSubject<Void, Never>()
    var didRequestLogoutPublisher: AnyPublisher<Void, Never> {
        didRequestLogoutSubject.eraseToAnyPublisher()
    }
    
    func loadServerData() async {
        showProgressView = true
        await refreshServerData()
        showProgressView = false
    }
    
    func refreshServerData() async {
        // Fake delay for nicer UX
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let serversResponse = await fetchServersResponse()
        persistServers(fromResponse: serversResponse)
        loadServers()
    }
    
    func changeSortType(to newSortType: SortType) {
        sortType = newSortType
    }
    
    func logout() {
        didRequestLogoutSubject.send()
    }
}

// MARK: - Private functionality

private extension ServerListViewModel {
    func fetchServersResponse() async -> ServerListResponse {
        let restClient = SwinjectUtility.resolve(.restClient)
        
        do {
            let components = RestClient.Constant.serverListPathComponents
            let response: ServerListResponse = try await restClient.executeRequest(
                components: components,
                method: .get,
                headers: nil
            )
            
            return response
        } catch {
            debugPrint("Server fetch from API failed", error)
            return []
        }
    }
    
    func persistServers(fromResponse response: ServerListResponse) {
        guard response.isEmpty == false else { return }
        
        let context = SwinjectUtility.resolve(.managedObjectContext)
        
        response.forEach { serverResponse in
            let server = Server(context: context)
            server.name = serverResponse.name
            server.distance = Int64(serverResponse.distance)
        }
        
        SwinjectUtility.resolve(.coreDataManager).saveContext(context)
    }
    
    func loadServers() {
        let context = SwinjectUtility.resolve(.managedObjectContext)
        do {
            let cdServers = try context.fetch(Server.fetchRequest())
            
            servers = cdServers.map {
                ServerDTO(name: $0.name ?? .emptyString, distance: Int($0.distance))
            }
        } catch {
            debugPrint("Server fetch from CoreData failed", error)
        }
    }
}
