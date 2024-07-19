//
//  TRMAccountVM.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import Foundation
import RxCocoa
import RxSwift
import FluentIcons

struct TRMSettingModel {
    let name: String
    let icon: FluentIcon
    let destination: AppDestination
}

class TRMAccountVM: ViewModelType {
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<TRMSettingModel>
    }
    
    struct Output {
        let settingItems: Driver<[TRMSettingModel]>
        let navigation: Driver<AppDestination>
    }
    
    func transform(_ input: Input) -> Output {
        
        let settingItems = input.trigger.map { _ -> [TRMSettingModel] in
            [TRMSettingModel(name: R.string.localizable.settinglanguagE.key.localized(), icon: .globe32Regular, destination: .language(viewModel: TRMLanguageVM()))]
        }
        
        let navigation = input.selection.map { model -> AppDestination in
            return model.destination
        }
        
        return Output(settingItems: settingItems,
                      navigation: navigation)
    }
}
