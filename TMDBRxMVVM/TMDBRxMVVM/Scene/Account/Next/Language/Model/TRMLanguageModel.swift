//
//  TRMLanguageModel.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import Foundation

struct TRMLanguageModel
{
    let language: String
    
    let displayName: String
    
    init(language: String) {
        self.language = language
        self.displayName = TMDBRxMVVM.displayLanguageName(language: language)
    }
}

func displayLanguageName(language: String) -> String
{
    let local = Locale(identifier: language)
    if let displayName = local.localizedString(forIdentifier: language) {
        return displayName.capitalized(with: local)
    }
    return String()
}


func tmdbLanguageName(language: String) -> String
{
    if language == "zh-Hans" {
        return "zh-CN"
    }
    return "en-US"
}

func tmdbRegionName(language: String) -> String
{
    if language == "zh-Hans" {
        return "cn"
    }
    return "us"
}
