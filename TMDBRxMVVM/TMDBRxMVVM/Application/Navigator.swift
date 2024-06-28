//
//  Navigator.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    // ``表示别名
    static let `default` = Navigator()
    
    // 列出所有场景
    enum Scene {
        case tabs(viewModel: TRMTabsVM)
    }
    
    private func get(scene: Scene) -> UIViewController {
        switch scene {
        case .tabs(let viewModel):
            let tabsVC = TRMTabsVC
        }
    }
    
    
}
