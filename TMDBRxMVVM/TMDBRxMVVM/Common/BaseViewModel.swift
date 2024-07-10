//
//  BaseViewModel.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

class BaseViewModel: NSObject {
    
    var networkingService: any NetworkServiceType
    let fetchTrigger = PublishSubject<Void>()
    var isLoading: BehaviorRelay<Bool>!
    let errorTracker = PublishRelay<String?>()
    
    private let disposeBag = DisposeBag()
    
    init(networkingService: any NetworkServiceType = NetworkingService<TRMTmdbApi>()) {
        self.networkingService = networkingService
        super.init()
        
        self.isLoading = BehaviorRelay(value: false)
        
        let fetchData = fetchTrigger
            .asObservable()
            .flatMapLatest { [weak self] _ -> Observable<Any> in
                guard let self = self else {
                    return .empty()
                }
                return self.fetchData()
                    .catchError({ error in
                        self.errorTracker.accept(error.localizedDescription)
                        return .empty()
                    })
            }
            .share()    // 缓存fetchData的结果
        
        fetchData
            .do(onSubscribed: {
                self.isLoading.accept(true)
            }, onDispose: {
                self.isLoading.accept(false)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    final func startRequest() {
        fetchTrigger.onNext(())
    }
    
    private func fetchData() -> Observable<Any> {
        fatalError("This method must be implemented by subclasses")
    }
}
