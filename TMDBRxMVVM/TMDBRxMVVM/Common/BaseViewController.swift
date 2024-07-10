//
//  BaseViewController.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/1.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var viewModel: BaseViewModel?
    private let disposeBag = DisposeBag()
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        defineLayout()
        bindViewModel()
    }
    
    func addSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.isLoading
            .subscribe { [weak self] loading in
                guard let self = self else { return }
                
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.center = self.view.center
                spinner.hidesWhenStopped = true
                if loading {
                    self.view.addSubview(spinner)
                    spinner.startAnimating()
                } else {
                    spinner.removeFromSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.errorTracker
            .subscribe { [weak self] errorMessage in
                guard let self = self else { return }
                print("Error: \(errorMessage ?? "Unknown Error")")
            }
            .disposed(by: disposeBag)
    }
}
