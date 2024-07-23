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
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let outputVMDriver: Driver<[TRMHomeSection]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let trendingRelay = BehaviorRelay<[TRMTrendingItem]>(value: [])
        let moviePopularRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        let movieTopRatedRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        // 触发趋势请求
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.trending(type: .all, timeWindow: .week))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { (rsp: TRMTrendingRsp) -> [TRMTrendingItem] in
                    return rsp.results!.filter{ $0.mediaType != .person}
                }
        }
        .drive { model in
            trendingRelay.accept(model)
        }
        .disposed(by: disposeBag)
        // 触发受欢迎电影请求
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.movieList(type: .popular, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMMovieListRsp) -> [TRMMovieListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            moviePopularRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.movieList(type: .top_rated, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMMovieListRsp) -> [TRMMovieListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            movieTopRatedRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        let items = Observable.combineLatest(trendingRelay, moviePopularRelay, movieTopRatedRelay)
            .map { (trendingModel, moviePopularModel, movieTopRatedModel) -> [TRMHomeSection] in
                let trendingItem = TRMHomeSectionItem.trending(data: trendingModel)
                let moviePopularItem = TRMHomeSectionItem.moviePopularList(data: moviePopularModel)
                let movieTopRatedItem = TRMHomeSectionItem.movieTopRatedList(data: movieTopRatedModel)
                var items: [TRMHomeSection] = []
                items.append(TRMHomeSection.home(title: "", items: [trendingItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.homepopular_MOVIE.key.localized(), items: [moviePopularItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.hometop_RATED_MOVIE.key.localized(), items: [movieTopRatedItem]))
                return items
            }
            .asDriverOnErrorJustComplete()
        
        return Output(outputVMDriver: items,
                      isLoading: activityIndicator.asDriver(),
                      error: errorTracker.asDriver())
    }
}
