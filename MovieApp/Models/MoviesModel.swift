//
//  MoviesModel.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 01/02/22.
//

import Foundation

struct MoviesModel: Codable {
    var title:String?
    var type:String?
    var results: [CollectionMoviesModel]?
}
