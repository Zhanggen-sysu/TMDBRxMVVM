//
//  TRMHomeListItemCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/22.
//

import UIKit

class TRMHomeListItemCell: BaseCollectionViewCell
{
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(scoreView)
        scoreView.layer.addSublayer(shapeLayer)
        scoreView.addSubview(scoreLabel)
    }
    
    override func defineLayout() {
        super.defineLayout()
        icon.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(icon.snp.width).multipliedBy(1.5)
        }
        
        scoreView.snp.makeConstraints { make in
            make.centerY.equalTo(icon.snp.bottom)
            make.left.equalTo(icon).offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.center.equalTo(scoreView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreView.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(contentView)
        }
    }
    
    override func bindModel() {
        super.bindModel()
        dataRelay.asDriverOnErrorJustComplete()
            .map { value -> Codable in
                if let model = value as? Codable {
                    return model
                }
                return TRMMovieListItem()
            }
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                if let movieModel = model as? TRMMovieListItem {
                    self.icon.kf.setImage(with: URL(string: "\(TRMConfig.TRMApiUrl.tmebImageUrl)\(TRMPosterSize.w342.rawValue)\(movieModel.posterPath ?? "")"), placeholder: R.image.default_poster())
                    self.nameLabel.text = movieModel.title
                    self.timeLabel.text = movieModel.releaseDate
                    self.scoreLabel.text = String(format: "%.1f", movieModel.voteAverage)
                    
                    self.shapeLayer.strokeEnd = movieModel.voteAverage / 10.0
                    self.shapeLayer.strokeColor = self.getStrokeColor(with: movieModel.voteAverage)
                } else if let tvModel = model as? TRMTVListItem {
                    self.icon.kf.setImage(with: URL(string: "\(TRMConfig.TRMApiUrl.tmebImageUrl)\(TRMPosterSize.w342.rawValue)\(tvModel.posterPath ?? "")"), placeholder: R.image.default_poster())
                    self.nameLabel.text = tvModel.name
                    self.timeLabel.text = tvModel.firstAirDate
                    self.scoreLabel.text = String(format: "%.1f", tvModel.voteAverage)
                    
                    self.shapeLayer.strokeEnd = tvModel.voteAverage / 10.0
                    self.shapeLayer.strokeColor = self.getStrokeColor(with: tvModel.voteAverage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getStrokeColor(with voteAverage: Double) -> CGColor
    {
        switch voteAverage {
        case 0..<2.5:
            return UIColor.red.cgColor
        case 2.5..<5:
            return UIColor.yellow.cgColor
        case 5..<7.5:
            return UIColor.orange.cgColor
        case 7.5...10:
            return UIColor.green.cgColor
        default:
            return UIColor.white.cgColor
        }
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 5
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.gray
        return timeLabel
    }()
    
    lazy var scoreView: UIView = {
        let scoreView = UIView()
        scoreView.layer.masksToBounds = true
        scoreView.layer.cornerRadius = 20
        scoreView.backgroundColor = UIColor.black
        return scoreView
    }()
    
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = .boldSystemFont(ofSize: 15)
        scoreLabel.textColor = UIColor.white
        return scoreLabel
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 18, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
}
