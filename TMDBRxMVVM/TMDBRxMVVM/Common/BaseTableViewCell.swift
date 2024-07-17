//
//  BaseTableViewCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
