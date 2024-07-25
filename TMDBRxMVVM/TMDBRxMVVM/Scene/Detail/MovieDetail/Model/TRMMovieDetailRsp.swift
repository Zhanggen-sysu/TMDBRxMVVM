//
//  TRMMovieDetailRsp.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/25.
//

import UIKit
import Foundation
import Localize_Swift

// MARK: - TRMMovieDetailRsp
class TRMMovieDetailRsp: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: TRMBelongsToCollection?
    let budget: Int?
    let genres: [TRMGenre]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [TRMProductionCompany]?
    let productionCountries: [TRMProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [TRMSpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    // local
    lazy var subTitleText: String = {
        if originalLanguage!.count > 0 && originalLanguage == Localize.currentLanguage() && originalTitle!.count > 0 {
            if releaseDate!.count > 0 {
                return "\(originalTitle!) (\(releaseDate!.prefix(4))"
            }
            return originalTitle!
        }
        return ""
    }()
    
    lazy var rateText: NSAttributedString = {
        var attributedString = TRMHelper.getRateAttributedString(with: voteAverage!, size: 24, space: 2)
        attributedString.append(NSAttributedString(string: String(format: "%.1f", voteAverage!), attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemYellow
        ]))
        attributedString.append(NSAttributedString(string: " / 10", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0.9, alpha: 1.0)
        ]))
        return attributedString
    }()

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool? = false, backdropPath: String? = "", belongsToCollection: TRMBelongsToCollection? = TRMBelongsToCollection(), budget: Int? = 0, genres: [TRMGenre]? = [], homepage: String? = "", id: Int? = 0, imdbID: String? = "", originCountry: [String]? = [], originalLanguage: String? = "", originalTitle: String? = "", overview: String? = "", popularity: Double? = 0, posterPath: String? = "", productionCompanies: [TRMProductionCompany]? = [], productionCountries: [TRMProductionCountry]? = [], releaseDate: String? = "", revenue: Int? = 0, runtime: Int? = 0, spokenLanguages: [TRMSpokenLanguage]? = [], status: String? = "", tagline: String? = "", title: String? = "", video: Bool? = false, voteAverage: Double? = 0, voteCount: Int? = 0) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

// MARK: - BelongsToCollection
class TRMBelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }

    init(id: Int? = 0, name: String? = "", posterPath: String? = "", backdropPath: String? = "") {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

// MARK: - Genre
class TRMGenre: Codable {
    let id: Int?
    let name: String?

    init(id: Int? = 0, name: String? = "") {
        self.id = id
        self.name = name
    }
}

// MARK: - ProductionCompany
class TRMProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }

    init(id: Int? = 0, logoPath: String? = "", name: String? = "", originCountry: String? = "") {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

// MARK: - ProductionCountry
class TRMProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }

    init(iso3166_1: String? = "", name: String? = "") {
        self.iso3166_1 = iso3166_1
        self.name = name
    }
}

// MARK: - SpokenLanguage
class TRMSpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }

    init(englishName: String? = "", iso639_1: String? = "", name: String? = "") {
        self.englishName = englishName
        self.iso639_1 = iso639_1
        self.name = name
    }
}
