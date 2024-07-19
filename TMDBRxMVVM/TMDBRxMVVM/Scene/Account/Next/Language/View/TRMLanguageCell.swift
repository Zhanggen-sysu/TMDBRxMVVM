//
//  TRMLanguageCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/19.
//

import UIKit
import SnapKit
import FluentIcons
import Localize_Swift

class TRMLanguageCell: BaseTableViewCell
{
    override func addSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(selectIcon)
    }
    
    override func defineLayout() {
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        selectIcon.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    override func bindModel() {
        dataRelay.asDriverOnErrorJustComplete()
            .map { value -> TRMLanguageModel in
                if let model = value as? TRMLanguageModel {
                    return model
                } else {
                    return TRMLanguageModel(language: Localize.currentLanguage())
                }
            }
            .drive { [weak self] model in
                guard let self = self else { return }
                self.label.text = model.displayName
            }
            .disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            selectIcon.isHidden = false
            label.textColor = .black
        } else {
            selectIcon.isHidden = true
            label.textColor = .gray
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    lazy var selectIcon: UIImageView = {
        let selectIcon = UIImageView();
        selectIcon.image = UIImage(fluent: .checkmark24Filled)
        selectIcon.isHidden = true
        return selectIcon
    }()
    
}
