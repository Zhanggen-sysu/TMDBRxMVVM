//
//  ReachabilityManager.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/8.
//

import RxSwift
import RxCocoa
import Alamofire

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()

    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var isReachable: Observable<Bool> {
        return reachSubject.asObservable()
    }

    override init() {
        super.init()

        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable:
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
        })
    }
}
