//
//  CommonExtension.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import Foundation
import Localize_Swift

extension StaticString {
    
    func localized() -> String {
        return description.localized()
    }
}
