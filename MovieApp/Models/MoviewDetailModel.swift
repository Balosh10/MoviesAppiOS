//
//  MoviewDetail.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation

// MARK: - Welcome
struct MovieDetailModel: Codable {
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
