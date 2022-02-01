//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import UIKit

class MovieDetailVC: BaseVC {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var realeseMovieLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var movieDetailViewModel:MovieDetailViewModel!
    var selectMovie:CollectionMoviesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.callToViewModelForUIUpdate()

    }

}

extension MovieDetailVC {
    
    private func setupUI(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.of(.arrow_white)!,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.dismissTap))
        self.view.backgroundColor = .black
        self.statusBarView(color: .black)
        self.navigationBarTransparente()
    }
    
    @objc
    func dismissTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension MovieDetailVC {
    
    func callToViewModelForUIUpdate(){
        self.activityIndicatorView = activityIndicatorView(this: self)
        self.movieDetailViewModel =  MovieDetailViewModel(movieResult:self.selectMovie!)
        self.movieDetailViewModel.bindMovieViewModelToController = {
            self.stopActivityIndicatorView(loader: self.activityIndicatorView, completion: { success in
                self.updateDataSource()
            })
        }
    }
    
    func updateDataSource(){
        
        guard self.movieDetailViewModel.errorRequest == nil else {
            alertCustom.shared.alertShow(self, message: self.movieDetailViewModel.errorRequest, completionHandler: { success in })
            return
        }
        
        guard let movieDetail = self.movieDetailViewModel.movieDetail,
              let posterPath = movieDetail.posterPath,
              let url:URL = URL(string: APIService.shared.imageBase + posterPath)
        else {
            return
        }
        
        self.movieImage.contentMode = .scaleAspectFill
        self.movieImage.load(url: url)
        self.titleMovieLabel.text = movieDetail.title ?? ""
        self.realeseMovieLabel.text = "Fecha de liberacion: \(movieDetail.releaseDate ?? "")"
        self.voteAverageLabel.text = "Votaciones\(movieDetail.voteAverage ?? 0)"
        let overview = NSMutableAttributedString().normal(movieDetail.overview ?? "", .white, .left, 14)
        self.overviewLabel.attributedText = overview
        self.overviewLabel.numberOfLines = 0
        self.titleMovieLabel.font = MvFont.GothamMedium.of(size: 22)
        self.realeseMovieLabel.font = MvFont.GothamBook.of(size: 14)
        self.voteAverageLabel.font = MvFont.GothamBook.of(size: 14)
        
    }

    
}
