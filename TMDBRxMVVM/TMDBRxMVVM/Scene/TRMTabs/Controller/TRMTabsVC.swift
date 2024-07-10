//
//  TRMTabsVC.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit
import RxSwift
import RxCocoa

class TRMTabsVC: UITabBarController {
    
    private let disposeBag = DisposeBag()
    var viewModel: TRMTabsVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let input = TRMTabsVM.Input()
        let output = viewModel.transform(input)
        output.tabs
            .drive { [weak self] tabsItem in
                guard let self = self else { return }
                let viewControllers = tabsItem.map{ item -> UIViewController in
                    let vc = Self.createViewController(for: item)
                    vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(fluent: item.icon), selectedImage: UIImage(fluent: item.selectedIcon))
                    return vc
                }
                self.viewControllers = viewControllers
            }
            .disposed(by: disposeBag)
    }
    
    static func createViewController(for item: TRMTabsItem) -> UIViewController {
        switch item.viewModel {
        case is TRMHomeVM:
            return TRMHomeVC(viewModel: item.viewModel)
        case is TRMDiscoverVM:
            return TRMDiscoverVC(viewModel: item.viewModel)
        default:
            fatalError("Unsupported view model type for tabs.")
        }
    }
}
