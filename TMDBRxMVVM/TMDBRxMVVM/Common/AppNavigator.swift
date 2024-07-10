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
    
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to destination: AppDestination) {
        
    }
}
