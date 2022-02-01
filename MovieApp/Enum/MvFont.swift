//
//  MFont.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import UIKit

enum sizeTitle:CGFloat {
    case smail = 12.0
    case medium = 14.0
    case large = 16.0
}

enum MvFont:String {
    case Gotham_Medium = "Gotham Medium"
    case Gotham_Bold = "Gotham Bold"
    case Gotham_Book = "Gotham Book"
    case GothamBook = "GothamBook"
    case GothamMedium = "GothamMedium"
    case GothamLight = "GothamLight"
    case RobotoCondensed_Bold = "RobotoCondensed-Bold"
    
        
    func of(size: CGFloat = 12) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
}
