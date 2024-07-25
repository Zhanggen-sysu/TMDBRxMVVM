//
//  TRMHelper.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/24.
//

import Foundation
import FluentIcons

class TRMHelper {
    static func getPosterUrl(with path: String, size: TRMPosterSize) -> String {
        return "\(TRMConfig.TRMApiUrl.tmdbImageUrl)\(size.rawValue)\(path)"
    }
    
    static func getBackdropUrl(with path: String, size: TRMBackdropSize) -> String {
        return "\(TRMConfig.TRMApiUrl.tmdbImageUrl)\(size.rawValue)\(path)"
    }
    
    static func getRateAttributedString(with score: Double, size: CGFloat, space: Int) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString()
        var tmp = score
        for index in 0...4 {
            let attach = NSTextAttachment()
            if tmp >= 2 {
                tmp -= 2
                attach.image = UIImage(fluent: .star24Filled).withTintColor(.systemYellow)
            } else if tmp >= 1.5 {
                tmp -= 1.5
                attach.image = UIImage(fluent: .starThreeQuarter24Regular).withTintColor(.systemYellow)
            } else if tmp >= 1 {
                tmp -= 1
                attach.image = UIImage(fluent: .starHalf24Regular).withTintColor(.systemYellow)
            } else if tmp >= 0.5 {
                tmp -= 0.5
                attach.image = UIImage(fluent: .starOneQuarter24Regular).withTintColor(.systemYellow)
            } else {
                attach.image = UIImage(fluent: .star24Regular).withTintColor(.systemYellow)
            }
            attach.bounds = CGRect(origin: CGPointZero, size: CGSize(width: size, height: size))
            attributedString.append(NSAttributedString(attachment: attach))
            attributedString.append(NSAttributedString(string: "".padding(toLength: space, withPad: " ", startingAt: 0)))
        }
        return attributedString
    }
}


