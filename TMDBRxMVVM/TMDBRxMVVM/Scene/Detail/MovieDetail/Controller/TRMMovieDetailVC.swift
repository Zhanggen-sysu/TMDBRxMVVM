//
//  TRMMovieDetailVC.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/24.
//

import UIKit
import SnapKit
import RxDataSources

class TRMMovieDetailVC: BaseViewController
{
    var dataSource: RxTableViewSectionedReloadDataSource<TRMHomeSection>?
    
    override func addSubviews() {
        super.addSubviews()
        self.view.addSubview(tableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        dataSource = RxTableViewSectionedReloadDataSource<TRMHomeSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case .movieDetailView(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: TRMCarouselCell.reuseID, for: indexPath) as! TRMCarouselCell
                    cell.dataRelay.accept(model)
                    return cell
                }
            })
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.refreshControl = UIRefreshControl()
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        // 不知道为什么底部多了20px，没找到好办法，就这样改吧
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
}

extension TRMMovieDetailVC: UITableViewDelegate
{
    
}
