//
//  TRMHomeVM.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class TRMHomeVM : ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let trmTrendingRsp: Driver<[TRMTrendingItem]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let trmTrendingRsp = input.trigger.flatMapLatest {
            return TRMTmdbNetwork.shared.fetchItem(.trending(type: .all, timeWindow: .week, language: "en-US"))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { (rsp: TRMTrendingRsp) -> [TRMTrendingItem] in
                    return rsp.results!.filter{ $0.mediaType != .person}
                }
        }
        
        return Output(trmTrendingRsp: trmTrendingRsp,
                      isLoading: activityIndicator.asDriver(),
                      error: errorTracker.asDriver())
    }
}
