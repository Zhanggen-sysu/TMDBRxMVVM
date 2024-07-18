//
//  TRMTrendindRsp.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/4.
//

import Foundation

// MARK: - TRMTrendingRsp
class TRMTrendingRsp: Codable {
    let page: Int?
    let results: [TRMTrendingItem]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int? = 0, results: [TRMTrendingItem]? = [], totalPages: Int? = 0, totalResults: Int? = 0) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - TRMTrendingItem
class TRMTrendingItem: Codable {
    let backdropPath: String?
    let id: Int?
    let title, originalTitle, overview, posterPath: String?
    let mediaType: TRMMediaType?
    let adult: Bool?
    let originalLanguage: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }

    init(backdropPath: String? = "", id: Int? = 0, title: String? = "", originalTitle: String? = "", overview: String? = "", posterPath: String? = "", mediaType: TRMMediaType? = .all, adult: Bool? = false, originalLanguage: String? = "", genreIDS: [Int]? = [], popularity: Double? = 0, releaseDate: String? = "", video: Bool? = false, voteAverage: Double? = 0, voteCount: Int? = 0, name: String? = "", originalName: String? = "", firstAirDate: String? = "", originCountry: [String]? = []) {
        self.backdropPath = backdropPath
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.mediaType = mediaType
        self.adult = adult
        self.originalLanguage = originalLanguage
        self.genreIDS = genreIDS
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.name = name
        self.originalName = originalName
        self.firstAirDate = firstAirDate
        self.originCountry = originCountry
    }
}
