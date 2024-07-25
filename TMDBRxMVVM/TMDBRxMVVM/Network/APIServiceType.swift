//
//  APIServiceType.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/8.
//

import Foundation
import RxSwift

protocol APIServiceType {
    func trending(type: TRMMediaType, timeWindow: TRMTimeWindow) -> Single<TRMTrendingRsp>
    func movieList(type: TRMMovieListType, page: Int) -> Single<TRMMovieListRsp>
    func tvList(type: TRMTVListType, page: Int) -> Single<TRMTVListRsp>
    
    func movieDetail(movieId: Int) -> Single<TRMMovieDetailRsp>
}
