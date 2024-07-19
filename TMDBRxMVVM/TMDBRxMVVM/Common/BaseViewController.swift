//
//  BaseViewController.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/1.
//

import UIKit
import RxSwift
import RxCocoa
import Localize_Swift

class BaseViewController: UIViewController {
    
    var viewModel: any ViewModelType
    let disposeBag = DisposeBag()
    // 语言变更事件
    let languageRelay = BehaviorRelay<Void>(value: ())
    
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        addSubviews()
        defineLayout()
        bindViewModel()
    }
    
    func addSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
    func bindViewModel() {
        NotificationCenter.default.rx
            .notification(NSNotification.Name(LCLLanguageChangeNotification))
            .subscribe { [weak self] _ in
                self?.languageRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
}
