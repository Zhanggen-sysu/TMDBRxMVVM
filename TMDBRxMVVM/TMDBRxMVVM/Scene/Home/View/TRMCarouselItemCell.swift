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
        super.addSubviews()
        contentView.addSubview(imageView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func bindModel() {
        super.bindModel()
        dataRelay.asDriverOnErrorJustComplete()
            .map{ value -> TRMTrendingItem in
                if let model = value as? TRMTrendingItem {
                    return model
                } else {
                    return TRMTrendingItem()
                }
            }
            .drive { [weak self] model in
                guard let self = self else { return }
                self.imageView.kf.setImage(with: URL(string: TRMHelper.getPosterUrl(with: model.posterPath ?? "", size: TRMPosterSize.w500)), placeholder: R.image.default_poster())
            }
            .disposed(by: disposeBag)
    }
    
    lazy var imageView: UIImageView = {
        return UIImageView()
    }()
}
