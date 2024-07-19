//
//  TRMSettingCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import UIKit
import SnapKit
import FluentIcons

class TRMSettingCell: BaseTableViewCell {
    
    override func addSubviews() {
        self.selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImg)
        contentView.addSubview(arrowImg)
    }
    
    override func defineLayout() {
        iconImg.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(iconImg.snp_rightMargin).offset(15)
        }
        
        arrowImg.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    override func bindModel() {
        dataRelay
            .asDriverOnErrorJustComplete()
            .map { value -> TRMSettingModel in
                if let model = value as? TRMSettingModel {
                    return model
                } else {
                    return TRMSettingModel(name: "", icon: .questionCircle32Regular, destination: .tabs(viewModel: TRMTabsVM()))
                }
            }
            .drive { [weak self] model in
                guard let self = self else { return }
                self.iconImg.image = UIImage(fluent: model.icon)
                self.nameLabel.text = model.name
            }
            .disposed(by: disposeBag)
            
    }
    
    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView()
        return iconImg
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        return nameLabel
    }()
    
    lazy var arrowImg: UIImageView = {
        let arrowImg = UIImageView()
        arrowImg.image = UIImage(fluent: .chevronRight24Filled)
        return arrowImg
    }()
}
