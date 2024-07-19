//
//  TRMTmdbApi.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/3.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import Localize_Swift

enum TRMTmdbApi {
    case trending(type: TRMMediaType, timeWindow: TRMTimeWindow)
}

extension TRMTmdbApi: TargetType {
    
    var baseURL: URL {
        return URL(string: TRMConfig.TRMApiUrl.tmdbBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .trending(let type, let timeWindow):
            return "trending/\(type.rawValue)/\(timeWindow.rawValue)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["api_key"] = TRMConfig.TRMApiKey.tmdb.apiKey
        switch self {
        case .trending(_, _):
            params["language"] = TMDBRxMVVM.tmdbLanguageName(language: Localize.currentLanguage())
        }
        return params
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
