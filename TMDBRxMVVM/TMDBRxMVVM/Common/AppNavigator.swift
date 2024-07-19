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
    case language(viewModel: TRMLanguageVM)
}

class AppNavigator {
    
    static let shared = AppNavigator()
    
    let navigationController: UINavigationController
    
    private init() {
        let tabsVC = TRMTabsVC(viewModel: TRMTabsVM())
        navigationController = UINavigationController(rootViewController: tabsVC)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func navigate(to destination: AppDestination) {
        switch destination {
        case .tabs(_):
            navigationController.popToRootViewController(animated: true)
        case .language(let viewModel):
            navigationController.pushViewController(TRMLanguageVC(viewModel: viewModel), animated: true)
        }
    }
}
