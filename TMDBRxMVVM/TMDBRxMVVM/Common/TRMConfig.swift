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
        static let tmdbImageUrl = "https://image.tmdb.org/t/p/"
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

// w * h = 2 * 3
enum TRMPosterSize: String {
    case w92, w154, w185, w342, w500, w780, original
}

// w * h = 16 * 9
enum TRMBackdropSize: String {
    case w300, w780, w1280, original
}

// w * h = 2 * 3
enum TRMProfileSize: String {
    case w45, w185, h632, original
}

// w * h = 1 * 1
enum TRMLogoSize: String {
    case w45, w92, w154, w185, w300, w500, original
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
