//
//  TRMMovieDetailCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/24.
//

import UIKit
import SnapKit
import FluentIcons
import Kingfisher
import TTGTags
import RxSwift
import RxCocoa

class TRMMovieDetailCell : BaseTableViewCell
{
    let magicColorRelay = BehaviorRelay<UIColor>(value: .white)
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(backdropImg)
        contentView.addSubview(detailContentView)
        detailContentView.addSubview(stackView)
        detailContentView.addSubview(overviewTitle)
        detailContentView.addSubview(overviewDetail)
        detailContentView.addSubview(expandBtn)
    }
    
    override func defineLayout() {
        backdropImg.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(screenWidth / 16 * 9)
        }
        
        detailContentView.snp.makeConstraints { make in
            make.top.equalTo(backdropImg.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
        }
        
        posterImg.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 128, height: 192))
            make.top.equalTo(backdropImg.snp.bottom).offset(-32)
            make.left.equalTo(contentView).offset(15)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(posterImg.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(backdropImg.snp.bottom).offset(10)
        }
        
        overviewTitle.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(posterImg.snp.bottom).offset(10)
            make.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
        }
        
        overviewDetail.snp.makeConstraints { make in
            make.top.equalTo(overviewTitle.snp.bottom).offset(10)
            make.left.right.equalTo(overviewTitle)
            make.bottom.equalTo(detailContentView).offset(-10)
        }
        
        expandBtn.snp.makeConstraints { make in
            make.top.bottom.equalTo(overviewTitle)
            make.right.equalTo(contentView).offset(-10)
            make.width.equalTo(150)
        }
    }
    
    override func bindModel() {
        dataRelay.asDriverOnErrorJustComplete()
            .map { value -> TRMMovieDetailRsp in
                if  let model = value as? TRMMovieDetailRsp {
                    return model
                }
                return TRMMovieDetailRsp()
            }
            .drive { [weak self] rsp in
                guard let self = self else { return }
                self.backdropImg.kf.setImage(with: URL(string: TRMHelper.getBackdropUrl(with: rsp.backdropPath ?? "", size: .w780)), placeholder: R.image.default_backdrop())
                self.posterImg.kf.setImage(with: URL(string: TRMHelper.getPosterUrl(with: rsp.posterPath ?? "", size: .w342)), placeholder: R.image.default_poster())
                
                self.titleLabel.isHidden = (rsp.title?.count == 0)
                self.titleLabel.text = rsp.title
                
                self.subTitleLabel.isHidden = (rsp.subTitleText.count == 0)
                self.subTitleLabel.text = rsp.subTitleText
                
                self.tagLineLabel.isHidden = (rsp.tagline?.count == 0)
                self.tagLineLabel.text = rsp.tagline
                
                self.ratingLabel.isHidden = (rsp.rateText.string.count == 0)
                self.ratingLabel.attributedText = rsp.rateText
                
                if rsp.genres!.count > 0 {
                    let style = TTGTextTagStyle()
                    style.borderWidth = 0
                    style.shadowOffset = CGSizeZero
                    style.shadowRadius = 0
                    style.extraSpace = CGSize(width: 8, height: 3)
                    for item in rsp.genres! {
                        let text = TTGTextTagStringContent()
                        text.text = item.name!
                        text.textFont = .systemFont(ofSize: 12)
                        text.textColor = .white
                        let textTag = TTGTextTag(content: text, style: style)
                        self.genresView.addTag(textTag)
                    }
                    self.genresView.reload()
                    self.genresView.isHidden = false
                } else {
                    self.genresView.isHidden = true
                }
                
                var detailTxt = ""
                if rsp.productionCountries!.count > 0 {
                    detailTxt += rsp.productionCountries!.first!.iso3166_1!
                }
                if rsp.releaseDate!.count > 0 {
                    detailTxt += " · \(rsp.releaseDate!)"
                }
                if rsp.runtime! > 0 {
                    detailTxt += " · \(rsp.runtime!/60)\("hr") \(rsp.runtime!%60)\("min")"
                }
                self.detailLabel.text = detailTxt
            }
            .disposed(by: disposeBag)
        
        magicColorRelay.asDriverOnErrorJustComplete()
            .drive { [weak self] color in
                guard let self = self else { return }
                self.detailContentView.backgroundColor = color
                for tag in genresView.allTags() {
                    tag.style.backgroundColor = color.deeperColor(with: -30)
                }
            }
            .disposed(by: disposeBag)
    }
    
    lazy var detailContentView: UIView = {
        let detailContentView = UIView()
        return detailContentView
    }()
    
    lazy var backdropImg: UIImageView = {
        let backdropImg = UIImageView()
        return backdropImg
    }()
    
    lazy var posterImg: UIImageView = {
        let posterImg = UIImageView()
        posterImg.layer.masksToBounds = true
        posterImg.layer.cornerRadius = 10
        return posterImg
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.font = .boldSystemFont(ofSize: 14)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textColor = .white
        return subTitleLabel
    }()
    
    lazy var tagLineLabel: UILabel = {
        let tagLineLabel = UILabel()
        tagLineLabel.font = .systemFont(ofSize: 14)
        tagLineLabel.textColor = UIColor(white: 0.9, alpha: 1)
        tagLineLabel.numberOfLines = 0
        return tagLineLabel
    }()
    
    lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        return ratingLabel
    }()
    
    lazy var genresView: TTGTextTagCollectionView = {
        let genresView = TTGTextTagCollectionView()
        genresView.enableTagSelection = false
        return genresView
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .white
        return detailLabel
    }()
    
    lazy var overviewTitle: UILabel = {
        let overviewTitle = UILabel()
        overviewTitle.font = .boldSystemFont(ofSize: 18)
        overviewTitle.textColor = .white
        return overviewTitle
    }()
    
    lazy var overviewDetail: UILabel = {
        let overviewDetail = UILabel()
        overviewDetail.font = .systemFont(ofSize: 14)
        overviewDetail.textColor = .white
        return overviewDetail
    }()
    
    lazy var expandBtn: UIButton = {
        let expandBtn = UIButton()
        expandBtn.backgroundColor = .clear
        expandBtn.setTitleColor(.white, for: .normal)
        expandBtn.titleLabel?.textColor = .white
        expandBtn.setImage(UIImage(fluent: .chevronDown16Regular), for: .normal)
        return expandBtn
    }()
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, tagLineLabel, ratingLabel, genresView, detailLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
}
