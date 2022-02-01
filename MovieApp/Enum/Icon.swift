//
//  Icon.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import UIKit
import Foundation

enum Img:String {
    case arrow_white
}

struct Icon {
    
    static func of(_ name:Img) -> UIImage? {
        return UIImage(named: name.rawValue)
    }
}

