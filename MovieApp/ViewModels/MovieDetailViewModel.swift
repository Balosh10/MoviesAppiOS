//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import UIKit

class MovieDetailViewModel : NSObject {
        
    private(set) var movieDetail:MovieDetailModel! {
        didSet {
            self.bindMovieViewModelToController()
        }
    }
    
    private(set) var errorRequest:String! {
        didSet {
            self.bindMovieViewModelToController()
        }
    }
    
    var bindMovieViewModelToController : (() -> ()) = {}

    init(movieResult: CollectionMoviesModel) {
        super.init()
        self.getMovieDetail(movieResult:movieResult)
    }

    func getMovieDetail(movieResult: CollectionMoviesModel) {
        guard let idSelect = movieResult.id,
              let idMovie = EncryptionTool.share.decrypString(string64:idSelect.toString()) else {
                  DispatchQueue.main.async {
                      self.errorRequest = Localizable.text(.Service_not_available)
                  }
            return
        }
        let id = idMovie.replacingOccurrences(of: "[Optional()]", with: "", options: .regularExpression, range: nil)
        APIService.shared.fetchMovieDetail(list: movieResult.type!,
                                           id: id,
                                           onSuccess: { response in
            DispatchQueue.main.async {
                self.movieDetail = response
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.errorRequest = error
            }
        })
    }
    
}
