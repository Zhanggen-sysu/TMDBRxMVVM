//
//  TRMAccountVC.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit
import SnapKit
import RxDataSources

class TRMAccountVC: BaseViewController {

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
        
        guard let viewModel = viewModel as? TRMAccountVM else { return }
        let input = TRMAccountVM.Input(trigger: languageRelay.asDriverOnErrorJustComplete(),
                                        selection: tableView.rx.modelSelected(TRMSettingModel.self).asDriverOnErrorJustComplete())
        let output = viewModel.transform(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TRMSettingModel>>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TRMSettingCell.reuseID, for: indexPath) as! TRMSettingCell
                cell.dataRelay.accept(item)
                return cell
            }
        )
        
        output.settingItems
            .map{ [SectionModel(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.navigation
            .drive { destination in
                AppNavigator.shared.navigate(to: destination)
            }
            .disposed(by: disposeBag)
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.register(TRMSettingCell.self, forCellReuseIdentifier: TRMSettingCell.reuseID)
        return tableView
    }()
}

