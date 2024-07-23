//
//  TRMHomeVC.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class TRMHomeVC: BaseViewController {
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? TRMHomeVM else { return }
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .take(1)    // 只自动刷新1次
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = TRMHomeVM.Input(trigger: Driver.merge(languageRelay.asDriver(), viewDidAppear, pull))
        let output = viewModel.transform(input);
        
        output.isLoading
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.error.drive(onNext: { error in
            print("Error: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<TRMHomeSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case .trending(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: TRMCarouselCell.reuseID, for: indexPath) as! TRMCarouselCell
                    cell.dataRelay.accept(model)
                    return cell
                case .moviePopularList(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: TRMHomeListCell.reuseID, for: indexPath) as! TRMHomeListCell
                    cell.dataRelay.accept(model)
                    return cell
                }
            }, titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            }
        )

        output.outputVMDriver
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func addSubviews() {
        super.addSubviews()
        self.view.addSubview(tableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        };
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.refreshControl = UIRefreshControl()
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.register(TRMCarouselCell.self, forCellReuseIdentifier: TRMCarouselCell.reuseID)
        tableView.register(TRMHomeListCell.self, forCellReuseIdentifier: TRMHomeListCell.reuseID)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        return tableView
    }()
}

extension TRMHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ceil(screenWidth * 3 / 2)
        }
        return UITableView.automaticDimension
    }
}
