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
    
    var viewModel: any ViewModelType
    let disposeBag = DisposeBag()
    
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
    }
}
