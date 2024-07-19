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
        let moviePopularRsp: Driver<[TRMMovieListItem]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        // 触发趋势请求
        let trmTrendingRsp = input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.trending(type: .all, timeWindow: .week))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { (rsp: TRMTrendingRsp) -> [TRMTrendingItem] in
                    return rsp.results!.filter{ $0.mediaType != .person}
                }
        }
        // 触发受欢迎电影请求
        let moviePopularRsp = input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.movieList(type: .popular, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMMovieListRsp) -> [TRMMovieListItem] in
                    return rsp.results ?? []
                }
        }
        
        return Output(trmTrendingRsp: trmTrendingRsp,
                      moviePopularRsp: moviePopularRsp,
                      isLoading: activityIndicator.asDriver(),
                      error: errorTracker.asDriver())
    }
}
