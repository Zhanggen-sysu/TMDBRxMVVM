//
//  TRMLanguageVM.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import Foundation
import RxSwift
import RxCocoa
import Localize_Swift

class TRMLanguageVM: ViewModelType
{
    struct Input {
        let saveTrigger: Driver<Void>
        let selection: Driver<TRMLanguageModel>
    }
    
    struct Output {
        let languages: Driver<[TRMLanguageModel]>
        let saved: Driver<Void>
    }
    
    private let languageRelay = BehaviorRelay<String>(value: Localize.currentLanguage())
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        input.selection.drive { lan in
            self.languageRelay.accept(lan.language)
        }
        .disposed(by: disposeBag)
        
        let languages = Driver.just(Localize.availableLanguages())
            .map { lans in
                lans.map { lan -> TRMLanguageModel in
                    return TRMLanguageModel(language: lan)
                }
            }
        
        let saved = input.saveTrigger.map { [weak self] _ in
            guard let self = self else { return }
            Localize.setCurrentLanguage(self.languageRelay.value)
        }
        
        return Output(languages: languages, saved: saved)
    }
}
