//
//  FlowCoordinator.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

/// Currently unused
@MainActor
final class FlowCoordinator: ObservableObject {
    enum FlowView: Hashable {
        case test
    }
    
    @Published var path = NavigationPath()
    
    func push(view: FlowView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build() -> some View {
        Text("New Flow")
    }
}
