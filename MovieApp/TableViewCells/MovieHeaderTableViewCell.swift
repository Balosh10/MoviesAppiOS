//
//  MovieHeaderTableViewCell.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import UIKit

class MovieHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var movie : SubCategoryModel? {
        didSet {
            movieTitleLabel.text = movie?.title ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .clear
        self.movieTitleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
