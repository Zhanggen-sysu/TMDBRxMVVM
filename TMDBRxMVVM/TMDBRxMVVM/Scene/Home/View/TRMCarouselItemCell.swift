//
//  TRMCarouselItemCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import UIKit
import SnapKit
import Kingfisher

class TRMCarouselItemCell : BaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
        return UIImageView()
    }()
    
    override func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    override func defineLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func bindModel(model: any Codable) {
        guard let model = model as? TRMTrendingItem else { return }
        imageView.kf.setImage(with: URL(string: String(format: "%@w500%@", TRMConfig.TRMApiUrl.tmebImageUrl, model.posterPath ?? "")), placeholder: UIImage(named: "default_poster"))
    }
    
}
