//
//  NetworkingService.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/8.
//

import Foundation
import RxSwift
import Moya

protocol NetworkServiceType {
    associatedtype TargetType: Moya.TargetType
    func fetchItem<T: Decodable>(_ target: TargetType) -> Single<T>
}

class NetworkingService<Target: TargetType>: NetworkServiceType {
    typealias TargetType = Target
    private let provider = MoyaProvider<Target>()
    
    func fetchItem<T: Decodable>(_ target: TargetType) -> Single<T> {
        return ReachabilityManager.shared.isReachable
            .filter { $0 }
            .take(1)
            .flatMapFirst { [provider] _ -> Single<Response> in
                provider.rx.request(target)
                    .filterSuccessfulStatusCodes()
            }
            .map { response -> T in
                let decodedObject = try JSONDecoder().decode(T.self, from: response.data)
                return decodedObject
            }
            .asSingle()
    }
}

