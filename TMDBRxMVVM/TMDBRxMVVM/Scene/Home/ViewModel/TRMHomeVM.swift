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
        let segmentTrigger: Driver<Int>
    }
    
    struct Output {
        let outputVMDriver: Driver<[TRMHomeSection]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let movieTrendingRelay = BehaviorRelay<[TRMTrendingItem]>(value: [])
        let tvTreandingRelay = BehaviorRelay<[TRMTrendingItem]>(value: [])
        let moviePopularRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        let movieTopRatedRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        let movieUpcomingRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        let movieNowPlayingRelay = BehaviorRelay<[TRMMovieListItem]>(value: [])
        let tvAiringTodayRelay = BehaviorRelay<[TRMTVListItem]>(value: [])
        let tvOnTheAirRelay = BehaviorRelay<[TRMTVListItem]>(value: [])
        let tvPopularRelay = BehaviorRelay<[TRMTVListItem]>(value: [])
        let tvTopRatedRelay = BehaviorRelay<[TRMTVListItem]>(value: [])
        
        // 触发趋势请求
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.trending(type: .movie, timeWindow: .week))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { (rsp: TRMTrendingRsp) -> [TRMTrendingItem] in
                    return rsp.results!.filter{ $0.mediaType != .person}
                }
        }
        .drive { model in
            movieTrendingRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.trending(type: .tv, timeWindow: .week))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { (rsp: TRMTrendingRsp) -> [TRMTrendingItem] in
                    return rsp.results!.filter{ $0.mediaType != .person}
                }
        }
        .drive { model in
            tvTreandingRelay.accept(model)
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
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.movieList(type: .upcoming, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMMovieListRsp) -> [TRMMovieListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            movieUpcomingRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.movieList(type: .now_playing, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMMovieListRsp) -> [TRMMovieListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            movieNowPlayingRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.tvList(type: .airing_today, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMTVListRsp) -> [TRMTVListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            tvAiringTodayRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.tvList(type: .on_the_air, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMTVListRsp) -> [TRMTVListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            tvOnTheAirRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.tvList(type: .popular, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMTVListRsp) -> [TRMTVListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            tvPopularRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        input.trigger.flatMapLatest { _ in
            return TRMTmdbNetwork.shared.fetchItem(.tvList(type: .top_rated, page: 1))
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ (rsp: TRMTVListRsp) -> [TRMTVListItem] in
                    return rsp.results ?? []
                }
        }
        .drive { model in
            tvTopRatedRelay.accept(model)
        }
        .disposed(by: disposeBag)
        
        // Observable.combineLatest最多8个需要分开写
        let movieItems = Observable.combineLatest(moviePopularRelay, movieTopRatedRelay, movieUpcomingRelay, movieNowPlayingRelay)
            .map { (moviePopularModel, movieTopRatedModel, movieUpcomingModel, movieNowPlayingModel) -> [TRMHomeSection] in
                let moviePopularItem = TRMHomeSectionItem.moviePopularList(data: moviePopularModel)
                let movieTopRatedItem = TRMHomeSectionItem.movieTopRatedList(data: movieTopRatedModel)
                let movieUpComingItem = TRMHomeSectionItem.movieUpcomingList(data: movieUpcomingModel)
                let movieNowPlayingItem = TRMHomeSectionItem.movieNowPlayingList(data: movieNowPlayingModel)
                var items: [TRMHomeSection] = []
                
                items.append(TRMHomeSection.home(title: R.string.localizable.homenow_PLAYING_MOVIE.key.localized(), items: [movieNowPlayingItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.homeupcoming_MOVIE.key.localized(), items: [movieUpComingItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.homepopular_MOVIE.key.localized(), items: [moviePopularItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.hometop_RATED_MOVIE.key.localized(), items: [movieTopRatedItem]))
                
                return items
            }
        
        let tvItems = Observable.combineLatest(tvAiringTodayRelay, tvOnTheAirRelay, tvPopularRelay, tvTopRatedRelay)
            .map { (tvAiringTodayModel, tvOnTheAirModel, tvPopularModel, tvTopRatedModel) in
                let tvAiringTodayItem = TRMHomeSectionItem.tvAiringTodayList(data: tvAiringTodayModel)
                let tvOnTheAirItem = TRMHomeSectionItem.tvOnTheAirList(data: tvOnTheAirModel)
                let tvPopularItem = TRMHomeSectionItem.tvPopularList(data: tvPopularModel)
                let tvTopRatedItem = TRMHomeSectionItem.tvTopRatedList(data: tvTopRatedModel)
                var items: [TRMHomeSection] = []
                items.append(TRMHomeSection.home(title: R.string.localizable.homeairing_TODAY_TV.key.localized(), items: [tvAiringTodayItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.homeon_THE_AIR_TV.key.localized(), items: [tvOnTheAirItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.homepopular_TV.key.localized(), items: [tvPopularItem]))
                items.append(TRMHomeSection.home(title: R.string.localizable.hometop_RATED_TV.key.localized(), items: [tvTopRatedItem]))
                
                return items
            }
        let items = Observable.combineLatest(input.segmentTrigger.asObservable(), movieTrendingRelay, tvTreandingRelay, movieItems, tvItems)
            .map { segment, movieTrendingModel, tvTrendingModel, movieArray, tvArray in
                var items: [TRMHomeSection] = []
                let movieTrendingItem = TRMHomeSectionItem.trending(data: movieTrendingModel)
                let tvTrendingItem = TRMHomeSectionItem.trending(data: tvTrendingModel)
                let segmentedItem = TRMHomeSectionItem.segmentSection(data: [])
                
                if segment == 0 {
                    items.append(TRMHomeSection.home(title: "", items: [movieTrendingItem]))
                    items.append(TRMHomeSection.home(title: "", items: [segmentedItem]))
                    items = items + movieArray
                } else {
                    items.append(TRMHomeSection.home(title: "", items: [tvTrendingItem]))
                    items.append(TRMHomeSection.home(title: "", items: [segmentedItem]))
                    items = items + tvArray
                }
                return items
            }
            .asDriverOnErrorJustComplete()
        return Output(outputVMDriver: items,
                      isLoading: activityIndicator.asDriver(),
                      error: errorTracker.asDriver())
    }
}
