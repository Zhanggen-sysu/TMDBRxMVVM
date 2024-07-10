//
//  APIServiceType.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/8.
//

import Foundation
import RxSwift

protocol APIServiceType {
    func trending(type: TRMMediaType, timeWindow: TRMTimeWindow, language: String) -> Single<TRMTrendingRsp>
}