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
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.refreshControl = UIRefreshControl()
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
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
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, [TRMTrendingItem]>>(
            configureCell: { dataSource, tableView, indexPath, items in
                let cell = tableView.dequeueReusableCell(withIdentifier: TRMCarouselCell.reuseID, for: indexPath) as! TRMCarouselCell
                cell.dataRelay.accept(items)
                return cell
            }
        )

        output.trmTrendingRsp
            .map{ [SectionModel(model: "", items: [$0])] }
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
            make.edges.equalTo(self.view)
        };
    }
}

extension TRMHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ceil(screenWidth * 3 / 2)
        }
        return UITableView.automaticDimension
    }
}
