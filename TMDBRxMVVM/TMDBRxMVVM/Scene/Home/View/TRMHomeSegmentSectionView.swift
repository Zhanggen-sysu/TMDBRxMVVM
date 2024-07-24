//
//  TRMHomeSegmentSectionView.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class TRMHomeSegmentSectionView: UITableViewHeaderFooterView {
    
    // 触发语言的更新
    let dataRelay = BehaviorRelay<Void>(value: ())
    
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
        contentView.addSubview(segmentedControl)
    }
    
    func defineLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
    }
    
    func bindModel() {
        dataRelay.asDriverOnErrorJustComplete()
            .drive { _ in
                segmentedControl.setTitle(R.string.localizable.homemoviE.key.localized(), forSegmentAt: 0)
                segmentedControl.setTitle(R.string.localizable.hometV.key.localized(), forSegmentAt: 1)
            }
    }
    
    lazy var segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Movies", "TVs"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .white
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.cornerRadius = 5
        return segmentedControl
    }()
}
