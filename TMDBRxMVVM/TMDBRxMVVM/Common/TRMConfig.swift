//
//  TRMConfig.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/3.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct TRMConfig {
    
    struct TRMApiUrl {
        static let tmdbBaseUrl = "https://api.themoviedb.org/3/"
        static let tmebImageUrl = "https://image.tmdb.org/t/p/"
    }
    
    enum TRMApiKey {
        case tmdb
        case marvel
        
        var apiKey: String {
            switch self {
            case .tmdb:
                return "748c16b2d0a067ab5e9055e41fc2754b"
            case .marvel:
                return ""
            }
        }
    }
}

enum TRMMovieListType: String {
    case now_playing, popular, top_rated, upcoming
}

enum TRMTVListType: String {
    case airing_today, on_the_air, popular, top_rated
}

enum TRMMediaType: String, Codable {
    case all, movie, tv, person
}

enum TRMTimeWindow: String {
    case day, week
}
