//
//  Application.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/6/28.
//

import UIKit

final class Application: NSObject {
    static let shared = Application()
    
    var window: UIWindow?
    
    private override init() {
        super.init()
    }
    
    func initializeFirstScreen(in window: UIWindow?) {
        
    }
    
}
