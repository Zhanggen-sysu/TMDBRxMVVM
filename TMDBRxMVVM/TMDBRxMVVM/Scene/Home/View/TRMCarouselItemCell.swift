//
//  TRMCarouselItemCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class TRMCarouselItemCell : BaseCollectionViewCell {
    
    override func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    override func defineLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func bindModel() {
        dataRelay.asDriverOnErrorJustComplete()
            .map{ value -> TRMTrendingItem in
                if let model = value as? TRMTrendingItem {
                    return model
                } else {
                    return TRMTrendingItem()
                }
            }
            .drive { model in
                self.imageView.kf.setImage(with: URL(string: String(format: "%@w500%@", TRMConfig.TRMApiUrl.tmebImageUrl, model.posterPath ?? "")), placeholder: UIImage(named: "default_poster"))
        }
        .disposed(by: disposeBag)
    }
    
    lazy var imageView: UIImageView = {
        return UIImageView()
    }()
}
