//
//  SceneDelegate.swift
//  Trends
//
//  Created by Mantas Svedas on 2020-09-06.
//  Copyright © 2020 Mantas Svedas. All rights reserved.
//

import SwiftData
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        #if DEBUG
        guard !isRunningUnitTests else { return }
        #endif
        
        setupDependencyInjection()
        
        let context = SwinjectUtility.resolve(.managedObjectContext)
        
        let mainView = MainView()
            .environment(\.managedObjectContext, context)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        SwinjectUtility.resolve(.coreDataManager).saveMainContext()
    }
}

// MARK: - Private functionality

private extension SceneDelegate {
    func setupDependencyInjection() {
        SwinjectUtility.registerDependencies()
    }
}

#if DEBUG
private extension SceneDelegate {
    var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
    }
    
    var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains { $0 == "-UITesting" }
    }
}
#endif
