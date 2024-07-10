//
//  AppDelegate.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            sceneConfiguration.delegateClass = SceneDelegate.self
        }
        return sceneConfiguration
    }
}

