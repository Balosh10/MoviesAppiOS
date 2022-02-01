//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    var movie : CollectionMoviesModel? {
        didSet {
            guard let url:URL = URL(string: APIService.shared.imageBase + (movie?.posterPath ?? ""))  else { return }
            movieImage.load(url: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
