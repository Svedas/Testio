//
//  MainView.swift
//  Testio
//
//  Created by Mantas Svedas on 04/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack {
            Group {
                appCoordinator.buildView()
            }
            .background(
                Image(asset: TestioAsset.backgroundImage)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    MainView()
}
