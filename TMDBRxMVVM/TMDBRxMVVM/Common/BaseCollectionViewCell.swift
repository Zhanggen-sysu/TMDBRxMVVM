//
//  BaseCollectionViewCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        defineLayout()
    }
    
    func addSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
    func bindModel(model: Codable) {
        
    }
}
