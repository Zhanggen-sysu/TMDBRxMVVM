//
//  TRMLanguageVC.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import Foundation
import RxDataSources
import Localize_Swift
import SnapKit
import UIKit

class TRMLanguageVC: BaseViewController 
{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func addSubviews() {
        super.addSubviews()
        self.title = R.string.localizable.settinglanguagE.key.localized()
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
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
        guard let viewModel = viewModel as? TRMLanguageVM else { return }
        
        let input = TRMLanguageVM.Input(saveTrigger: saveBarButtonItem.rx.tap.asDriverOnErrorJustComplete(),
                                        selection: tableView.rx.modelSelected(TRMLanguageModel.self).asDriverOnErrorJustComplete())
        let output = viewModel.transform(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TRMLanguageModel>>(
            configureCell: { dataSource, tableView, indexPath, model in
                let cell = tableView.dequeueReusableCell(withIdentifier: TRMLanguageCell.reuseID, for: indexPath) as! TRMLanguageCell
                cell.dataRelay.accept(model)
                if model.language == Localize.currentLanguage() {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
                }
                return cell
            }
        )

        output.languages
            .map{ [SectionModel(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.saved
            .drive { _ in
                AppNavigator.shared.pop(animated: true)
            }
            .disposed(by: disposeBag)
        
        languageRelay.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.title = R.string.localizable.settinglanguagE.key.localized()
            self.saveBarButtonItem.title = R.string.localizable.settinglanguagesavE.key.localized()
        }
        .disposed(by: disposeBag)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.rowHeight = 44
        tableView.register(TRMLanguageCell.self, forCellReuseIdentifier: TRMLanguageCell.reuseID)
        return tableView
    }()
    
    lazy var saveBarButtonItem : UIBarButtonItem = {
        return UIBarButtonItem(title: R.string.localizable.settinglanguagesavE.key.localized(), style: .plain, target: nil, action: nil)
    }()
}
