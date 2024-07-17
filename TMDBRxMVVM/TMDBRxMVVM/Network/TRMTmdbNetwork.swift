//
//  TRMTmdbNetwork.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import Foundation
import RxSwift

public final class TRMTmdbNetwork {
    static let shared = NetworkingService<TRMTmdbApi>()
}
