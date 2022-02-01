//
//  LocalizableDelegate.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 30/01/22.
//

import Foundation

protocol LocalizableDelegate {
    
    var rawValue:String { get }
    var table:String? { get }
    var localized:String { get }

}

extension LocalizableDelegate {
    
    var localized:String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }
    
    var table:String? {
        return nil
    }
    
}

enum Localizable {
    
    enum description:String,LocalizableDelegate {
        case title_app
        case films
        case tv_shows
        case favorites
        case recommended
        case top_rated
        case empty_list_movie_tv
    }
    
    enum error:String,LocalizableDelegate {
        case Service_not_available
        case without_internet
    }
    
    static func text(_ description:description) -> String {
        return description.localized
    }
    
    static func text(_ description:error) -> String {
        return description.localized
    }
    
}
