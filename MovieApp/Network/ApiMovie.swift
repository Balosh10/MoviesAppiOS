//
//  ApiMovie.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import Foundation

extension APIService {
    
    func fetchMovie(list:List,
                    result:Result,
                    id:Int? = nil,
                    onSuccess: @escaping (MoviesModel) -> (),
                    onFailure: @escaping (String) -> ()){
        
        self.apiRequest("\(BASE_GATEWAY)\(list)/\(result)?api_key=\(apiKey)&language=es-MX&page=1",
                        MoviesModel.self,
                        onSuccess: { response in
            onSuccess(response)
        }, onFailure: { error in
            onFailure(error)
        })
        
    }
    
    func fetchMovieDetail(list:String,
                          id:String,
                          onSuccess: @escaping (MovieDetailModel) -> (),
                          onFailure: @escaping (String) -> ()){
        
        self.apiRequest("\(BASE_GATEWAY)\(list)/\(id)?api_key=\(apiKey)&language=es-MX&page=1",
                        MovieDetailModel.self,
                        onSuccess: { response in
            onSuccess(response)
        }, onFailure: { error in
            onFailure(error)
        })
        
    }
    
    func fetchMovieRecommendations(list:List,
                                   id:Int,
                                   onSuccess: @escaping (MoviesModel) -> (),
                                   onFailure: @escaping (String) -> ()){
        
        self.apiRequest("\(BASE_GATEWAY)\(list)/\(id)/\(Result.recommendations.rawValue)?api_key=\(apiKey)&language=es-MX&page=1",
                        MoviesModel.self,
                        onSuccess: { response in
            onSuccess(response)
        }, onFailure: { error in
            onFailure(error)
        })
        
    }
}
