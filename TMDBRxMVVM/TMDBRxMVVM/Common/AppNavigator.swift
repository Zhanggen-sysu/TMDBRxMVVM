//
//  AppNavigator.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/10.
//

import Foundation
import UIKit

enum AppDestination {
    case tabs(viewModel: TRMTabsVM)
}

class AppNavigator {
    
    static let shared = AppNavigator()
    
    let navigationController: UINavigationController
    
    private init() {
        let tabsVM = TRMTabsVM()
        let tabsVC = TRMTabsVC(viewModel: tabsVM)
        navigationController = UINavigationController(rootViewController: tabsVC)
    }
    
    func navigate(to destination: AppDestination) {
        switch destination {
        case .tabs(let viewModel):
            navigationController.popToRootViewController(animated: true)
        }
    }
}
