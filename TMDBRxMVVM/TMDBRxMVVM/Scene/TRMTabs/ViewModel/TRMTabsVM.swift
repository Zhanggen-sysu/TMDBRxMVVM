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

enum TRMTabsItem: Int {
    case home, discover, account
    
    var icon: FluentIcon {
        switch self {
        case .home:
            return .home24Regular
        case .discover:
            return .search24Regular
        case .account:
            return .personCircle24Regular
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return R.string.localizable.tabshomE.key.localized()
        case .discover:
            return R.string.localizable.tabsdiscoveR.key.localized()
        case .account:
            return R.string.localizable.tabsaccounT.key.localized()
        }
    }
    
    var selectedIcon: FluentIcon {
        switch self {
        case .home:
            return .home24Filled
        case .discover:
            return .search24Filled
        case .account:
            return .personCircle24Filled
        }
    }
    
    var viewModel: any ViewModelType {
        switch self {
        case .home:
            return TRMHomeVM()
        case .discover:
            return TRMDiscoverVM()
        case .account:
            return TRMAccountVM()
        }
    }
}

class TRMTabsVM: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let tabs: Driver<[TRMTabsItem]>
    }
    
    func transform(_ input: Input) -> Output {
        let tabs = Driver.just([
            TRMTabsItem.home, TRMTabsItem.discover, TRMTabsItem.account
        ])
        
        return Output(tabs: tabs)
    }
}
