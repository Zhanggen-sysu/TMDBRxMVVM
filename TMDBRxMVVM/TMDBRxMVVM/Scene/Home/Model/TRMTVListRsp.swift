//
//  TRMTVListRsp.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/24.
//

import Foundation

// MARK: - TRMTVListRsp
class TRMTVListRsp: Codable {
    let page: Int?
    let results: [TRMTVListItem]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int? = 0, results: [TRMTVListItem]? = [], totalPages: Int? = 0, totalResults: Int? = 0) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class TRMTVListItem: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName, overview: String?
    let popularity: Double?
    let posterPath, firstAirDate, name: String?
    let voteAverage: Double
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool? = false, backdropPath: String? = "", genreIDS: [Int]? = [], id: Int? = 0, originCountry: [String]? = [], originalLanguage: String? = "", originalName: String? = "", overview: String? = "", popularity: Double? = 0, posterPath: String? = "", firstAirDate: String? = "", name: String? = "", voteAverage: Double = 0, voteCount: Int? = 0) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.name = name
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
