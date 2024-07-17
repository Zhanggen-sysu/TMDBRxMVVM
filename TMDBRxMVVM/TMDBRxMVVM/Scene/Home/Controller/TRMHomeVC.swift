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

class TRMHomeVC: BaseViewController {
    
    private var model: [Any] = []
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.refreshControl = UIRefreshControl()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TRMCarouselCell.self, forCellReuseIdentifier: TRMCarouselCell.reuseID)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        return tableView
    }()
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? TRMHomeVM else { return }
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = TRMHomeVM.Input(trigger: Driver.merge(viewDidAppear, pull))
        let output = viewModel.transform(input);
        
        output.isLoading
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.error.drive(onNext: { error in
            print("Error: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
        
        output.trmTrendingRsp.drive(onNext: { [weak self] items in
            guard let self = self else { return }
            self.model.insert(items, at: 0)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func addSubviews() {
        super.addSubviews()
        self.view.addSubview(tableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        };
    }
}

extension TRMHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = model[indexPath.row]
        switch item {
        case _ as [TRMTrendingItem]:
            return ceil(screenWidth * 3 / 2)
        default:
            return UITableView.automaticDimension
        }
    }
}

extension TRMHomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = model[indexPath.row]
        
        switch item {
        case let trendingItems as [TRMTrendingItem]:
            let cell = tableView.dequeueReusableCell(withIdentifier: TRMCarouselCell.reuseID, for: indexPath) as! TRMCarouselCell
            cell.bindModel(model: trendingItems)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
