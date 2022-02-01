//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: MovieCollectionViewCell?,
                        selectMovie: CollectionMoviesModel?,
                        didTappedInTableViewCell: MovieTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieCollectioViewCell: UICollectionView!
    static var cellCollectionViewIdentifier = "MovieCollectionViewCell"
    
    private var collectiondataSource : MovieCollectionViewDataSource<MovieCollectionViewCell, CollectionMoviesModel>!
    private var collectionDelegate : MovieCollectionViewDelegate<MovieCollectionViewCell, CollectionMoviesModel>!
    weak var cellDelegate: MovieCollectionViewCellDelegate?

    var movie : SubCategoryModel? {
        didSet {
            movieNameLabel.text = movie?.title ?? ""
        }
    }
    
}

extension MovieTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.movieNameLabel.textColor = .white
        
        // TODO: need to setup collection view flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: 80, height: 100)
        flowLayout.minimumLineSpacing = 6
        flowLayout.minimumInteritemSpacing = 16
        self.movieCollectioViewCell.collectionViewLayout = flowLayout
        self.movieCollectioViewCell.showsHorizontalScrollIndicator = false
        
        self.movieCollectioViewCell.register(UINib(nibName: MovieTableViewCell.cellCollectionViewIdentifier, bundle: .main),
                                             forCellWithReuseIdentifier: MovieTableViewCell.cellCollectionViewIdentifier)
    }
    
    var collectionViewOffset: CGFloat {
        set { movieCollectioViewCell.contentOffset.x = newValue }
        get { return movieCollectioViewCell.contentOffset.x }
    }
    
    func updateCellWith(row: [CollectionMoviesModel]?) {
        self.collectiondataSource = MovieCollectionViewDataSource(cellIdentifier: MovieTableViewCell.cellCollectionViewIdentifier,
                                                                  items: row,
                                                                  configureCell: { (cellCollection, itemMovie) in
            cellCollection.movieImage.setRadiusProfile()
            cellCollection.movieImage.contentMode = .scaleToFill
            let posterPathDesencryp =  EncryptionTool.share.decrypString(string64: (itemMovie?.posterPath ?? ""))  ?? ""
            guard let url:URL = URL(string: APIService.shared.imageBase + posterPathDesencryp)  else { return }
            cellCollection.movieImage.load(url: url)

        })
        
        self.collectionDelegate = MovieCollectionViewDelegate(cellIdentifier: MovieTableViewCell.cellCollectionViewIdentifier,
                                                              items: row,
                                                              configureCell: { (cellCollection, itemMovie) in
            self.cellDelegate?.collectionView(collectionviewcell: cellCollection,
                                              selectMovie: itemMovie,
                                              didTappedInTableViewCell: self)
        })
        
        self.movieCollectioViewCell.delegate = self.collectionDelegate
        self.movieCollectioViewCell.dataSource = self.collectiondataSource
        self.movieCollectioViewCell.reloadData()
    }
}
