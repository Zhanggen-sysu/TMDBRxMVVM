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
            .filter { $0 }      // 网络连接可用时
            .take(1)            // 只取第一次网络变为可用
            .flatMapLatest { [provider] _ -> Single<Response> in // 首次网络通畅时就发起请求，[provider]是闭包捕获列表，避免循环引用，_表示闭包不使用flatMapFirst传递的元素（这里是true事件），Single<Response>是闭包返回值
                provider.rx.request(target)
                    .do(onSuccess: { rsp in
                        let json = String(data: rsp.data, encoding: .utf8) ?? ""
                        print("Request Url: \(rsp.request?.url?.absoluteString ?? "")\nResponse JSON: \(json)")
                    }, onError: { error in
                        print("Request Error: \(error)")
                    }, onSubscribe: {
                        print("Web service call started for: \(target)\n")
                    })
                    .filterSuccessfulStatusCodes()
            }
            .map { response -> T in
                let decodedObject = try JSONDecoder().decode(T.self, from: response.data)
                return decodedObject
            }
            .catchError { error in
                print("Parse Error: \(error)")
                return .empty()
            }
            .asSingle()
    }
}

