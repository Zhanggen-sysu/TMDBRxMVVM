//
//  BaseViewModel.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import Foundation

protocol ViewModelType {
    // 关联类型：占位用，具体类型到实际遵循时被指定（每个VM内部的struct定义不同）
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {
    
}
