//
//  SceneDelegate.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = AppNavigator.shared.navigationController;
        window?.makeKeyAndVisible()
    }
}
