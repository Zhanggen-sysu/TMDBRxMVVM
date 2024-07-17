//
//  TRMTabsVM.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import Foundation
import RxSwift
import RxCocoa
import FluentIcons

struct TRMTabsItem {
    let viewModel: any ViewModelType
    let title: String
    let icon: FluentIcon
    let selectedIcon: FluentIcon
}

class TRMTabsVM: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let tabs: Driver<[TRMTabsItem]>
    }
    
    func transform(_ input: Input) -> Output {
        let tabs = Observable.just([
            TRMTabsItem(viewModel: TRMHomeVM(), title: "Home", icon: .home24Regular, selectedIcon: .home24Filled),
            TRMTabsItem(viewModel: TRMDiscoverVM(), title: "Discover", icon: .search24Regular, selectedIcon: .search24Filled),
        ])
            .asDriver { error in
                print("Error: \(error.localizedDescription)")
                return Driver.empty()
            }
        
        return Output(tabs: tabs)
    }
}
