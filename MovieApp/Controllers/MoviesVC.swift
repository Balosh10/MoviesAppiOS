//
//  MoviesVC.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 28/01/22.
//

import UIKit

class MoviesVC: BaseVC {

    @IBOutlet weak var movieTableView: UITableView!
    
    private var movieViewModel : MovieViewModel!
    private var tableDataSource : MovieTableViewDataSource<MovieTableViewCell, SubCategoryModel>!
    private var tableDelegate : MovieTableViewDelegate<MovieHeaderTableViewCell, SubCategoryModel>!

    private var cellIdentifier = "MovieTableViewCell"
    private var headerCellIdentifier = "MovieHeaderTableViewCell"
    private var selectMovie:CollectionMoviesModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.callToViewModelForUIUpdate()
    }

}
extension MoviesVC {
    
    private func setupUI(){
        DispatchQueue.main.async {
            self.movieTableView.delegate = self.tableDelegate
            self.movieTableView.dataSource = self.tableDataSource
            self.movieTableView.register(UINib(nibName: self.cellIdentifier, bundle: .main),
                                         forCellReuseIdentifier: self.cellIdentifier)
            self.movieTableView.register(UINib(nibName: self.headerCellIdentifier, bundle: .main),
                                         forCellReuseIdentifier: self.headerCellIdentifier)
            self.movieTableView.reloadData()
        }
        self.movieTableView.backgroundColor = .black
        self.movieTableView.separatorColor = UIColor.black
        self.movieTableView.separatorStyle = .none

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailsViewVontrollerSeg" {
            if let movieDetailVC = segue.destination as? UINavigationController,
                let targetController = movieDetailVC.topViewController as? MovieDetailVC {
                targetController.selectMovie = self.selectMovie
            }
        }

    }
    
}
extension MoviesVC {
    
    func callToViewModelForUIUpdate(){
        self.activityIndicatorView = activityIndicatorView(this: self)
        self.movieViewModel =  MovieViewModel()
        self.movieViewModel.bindMovieViewModelToController = {
            self.stopActivityIndicatorView(loader: self.activityIndicatorView, completion: { success in
                guard self.movieViewModel.messageError == nil else {
                    self.alertShow()
                    return
                }
                self.updateDataSourceDelegate(movies: self.movieViewModel.movieData.moviesTV)
            })
        }
    }
    
    private func alertShow(){
        alertCustom.shared.alertShow(self,
                                     message: self.movieViewModel.messageError,
                                     completionHandler: { success in })
    }
    
    private func loadMovieOrTvShowOffline(){
        self.updateDataSourceDelegate(movies: self.movieViewModel.movieData.moviesTV)

    }
    
    func updateDataSourceDelegate(movies:[SubCategoryModel]){
        
        self.tableDataSource = MovieTableViewDataSource(cellIdentifier: self.cellIdentifier,
                                                        items: movies,
                                                        configureCell: { (cell, movieTV) in
            // Show Sub Category Title
            cell.movieNameLabel.text = EncryptionTool.share.decrypString(string64: movieTV.title ?? "")  ?? ""
            cell.movieNameLabel.font = MvFont.GothamMedium.of(size: 14)
            // Pass the data to colletionview inside the tableviewcell
//            cell.updateCellWith(row: movieTV.results?.sorted(by: { $0.voteCount! > $1.voteCount! }))
            cell.updateCellWith(row: movieTV.results)
            // Set cell's delegate
            cell.cellDelegate = self
        })
        
        self.tableDelegate = MovieTableViewDelegate(cellIdentifier:self.headerCellIdentifier,
                                                    items: movies,
                                                    configureCell: { (cell, evm) in
            // Show Category Title
            cell.movieTitleLabel.text = EncryptionTool.share.decrypString(string64: evm.title)  ?? ""
            cell.movieTitleLabel.font = MvFont.GothamMedium.of(size: 18)
        })
        self.setupUI()
        
        if movies.count <= 0 {
            alertCustom.shared.alertShow(self, message:  "No se pueden ver las listas por el momento.", completionHandler: { success in })
        }
    }
    

}

extension MoviesVC: MovieCollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: MovieCollectionViewCell?,
                        selectMovie: CollectionMoviesModel?,
                        didTappedInTableViewCell: MovieTableViewCell) {
        let section = didTappedInTableViewCell.tag 
        self.selectMovie = selectMovie
        self.selectMovie?.type = ListSection.init(rawValue: section) == .tv ? (List.tv.rawValue) : (List.movie.rawValue)
        performSegue(withIdentifier: "movieDetailsViewVontrollerSeg", sender: self)
            // You can also do changes to the cell you tapped using the 'collectionviewcell'
    }
}
