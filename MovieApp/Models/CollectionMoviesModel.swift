//
//  TopRatedModel.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 28/01/22.
//

import Foundation


struct CollectionMoviesModel: Codable  {
    var title:String?
    var type:String?
    var id: customType?
    var posterPath: String?
    var voteCount:customType?
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case id
        case posterPath = "poster_path"
        case voteCount = "vote_count"
    }
    
    init(title: String? = nil, type: String? = nil, id: customType? = nil, posterPath:String? = nil, voteCount:customType? = nil) {
        self.title = title
        self.type = type
        self.id = id
        self.posterPath = posterPath
        self.voteCount = voteCount
    }
    
}
//
//Mark: Custom type id and voteCount
enum customType: Codable {
  case int(Int)
  case string(String)

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = try .int(container.decode(Int.self))
    } catch DecodingError.typeMismatch {
      do {
        self = try .string(container.decode(String.self))
      } catch DecodingError.typeMismatch {
        throw DecodingError.typeMismatch(customType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .int(let int):
      try container.encode(int)
    case .string(let string):
      try container.encode(string)
    }
  }
    
  func toString() -> String {
    switch self {
    case .string(let num):
        return num
    case .int(_):
        return ""
    }
  }

  func toInt() -> Int {
    switch self {
    case .int(let num):
        return num
    case .string(let _):
        return 0
    }
  }
    
}
