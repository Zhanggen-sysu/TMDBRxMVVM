//
//  TRMHomeSectionView.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/23.
//

import UIKit
import FluentIcons
import SnapKit
import RxSwift
import RxCocoa

class TRMHomeSectionView: UITableViewHeaderFooterView {
    
    let dataRelay = BehaviorRelay<TRMHomeSection?>(value: nil)
    private let disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        self.addSubviews()
        self.defineLayout()
        self.bindModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(seeMoreView)
        seeMoreView.addSubview(seeMoreLabel)
        seeMoreView.addSubview(arrowIcon)
    }
    
    func defineLayout() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(15)
        }
        seeMoreView.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(150)
        }
        arrowIcon.snp.makeConstraints { make in
            make.right.equalTo(seeMoreView).offset(-10)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        seeMoreLabel.snp.makeConstraints { make in
            make.right.equalTo(arrowIcon.snp.left)
            make.centerY.equalTo(arrowIcon)
        }
    }
    
    func bindModel() {
        dataRelay.asDriverOnErrorJustComplete()
            .drive { [weak self] item in
                guard let self = self else { return }
                self.titleLabel.text = item?.title
                self.seeMoreLabel.text = R.string.localizable.homesee_MORE.key.localized()
            }
            .disposed(by: disposeBag)
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        return titleLabel
    }()
    
    lazy var seeMoreView: UIView = {
        let seeMoreView = UIView()
        seeMoreView.backgroundColor = .white
        return seeMoreView
    }()
    
    lazy var seeMoreLabel: UILabel = {
        let seeMoreLabel = UILabel()
        seeMoreLabel.textColor = .systemBlue
        seeMoreLabel.font = .systemFont(ofSize: 14)
        return seeMoreLabel
    }()
    
    lazy var arrowIcon: UIImageView = {
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(fluent: .chevronRight20Regular)
        return arrowIcon
    }()
}
