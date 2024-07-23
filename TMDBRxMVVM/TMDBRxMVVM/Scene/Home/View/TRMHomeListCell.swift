//
//  TRMHomeListCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/19.
//

import UIKit
import SnapKit
import Kingfisher
import RxDataSources

class TRMHomeListCell: BaseTableViewCell
{
    override func addSubviews() {
        contentView.addSubview(collectionView)
    }
    
    override func defineLayout() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(320)
        }
    }
    
    override func bindModel() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Codable>> {
            dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TRMHomeListItemCell.reuseID, for: indexPath) as! TRMHomeListItemCell
            cell.dataRelay.accept(item)
            return cell
        }
        
        dataRelay.asDriverOnErrorJustComplete()
            .map { value -> [SectionModel] in
                if let model = value as? [Codable] {
                    return [SectionModel(model: "", items: model)]
                } else {
                    return []
                }
            }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 320)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(TRMHomeListItemCell.self, forCellWithReuseIdentifier: TRMHomeListItemCell.reuseID)
        return collectionView
    }()
}
