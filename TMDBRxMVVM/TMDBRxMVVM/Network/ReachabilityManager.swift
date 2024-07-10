//
//  ReachabilityManager.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/8.
//

import Reachability
import RxReachability
import RxSwift
import RxCocoa

class ReachabilityManager {
    private let reachability: Reachability
    
    static let shared = ReachabilityManager()
    
    var isReachable: Observable<Bool> {
        return reachability.rx.isReachable
    }
    
    private init() {
        reachability = try! Reachability()
        do {
            try reachability.startNotifier()
        } catch {
            print("Error occurred while starting reachability notifier: \(error)")
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}
