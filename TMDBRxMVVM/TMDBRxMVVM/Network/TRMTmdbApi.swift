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

enum TRMTmdbApi {
    case trending(type: TRMMediaType, timeWindow: TRMTimeWindow, language: String)
}

extension TRMTmdbApi: TargetType {
    
    var baseURL: URL {
        return URL(string: TRMConfig.TRMApiUrl.tmdbBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .trending(let type, let timeWindow, _):
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
        switch self {
        case .trending(_, _, let language):
            params["language"] = language
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
