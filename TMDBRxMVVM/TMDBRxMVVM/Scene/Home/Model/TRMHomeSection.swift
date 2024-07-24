//
//  TRMHomeSection.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/19.
//

import Foundation
import Differentiator

enum TRMHomeSectionItem {
    case trending(data: [TRMTrendingItem])
    case segmentSection(data: [String])
    
    case moviePopularList(data: [TRMMovieListItem])
    case movieTopRatedList(data: [TRMMovieListItem])
    case movieUpcomingList(data: [TRMMovieListItem])
    case movieNowPlayingList(data: [TRMMovieListItem])
    
    case tvAiringTodayList(data: [TRMTVListItem])
    case tvOnTheAirList(data: [TRMTVListItem])
    case tvPopularList(data: [TRMTVListItem])
    case tvTopRatedList(data: [TRMTVListItem])
}

enum TRMHomeSection {
    case home(title: String, items: [TRMHomeSectionItem])
}

extension TRMHomeSection: SectionModelType
{
    typealias Item = TRMHomeSectionItem
    
    var title: String {
        switch self {
        case .home(let title, _): return title
        }
    }
    
    var items: [TRMHomeSectionItem] {
        switch self {
        case .home(_, let items): return items
        }
    }
    
    init(original: TRMHomeSection, items: [TRMHomeSectionItem]) {
        switch original {
        case .home(let title, let items):
            self = .home(title: title, items: items)
        }
    }
}


