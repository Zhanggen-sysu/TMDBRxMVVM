//
//  AppDelegate.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Application.shared.initializeFirstScreen(in: window!)
        
        return true
    }
}

