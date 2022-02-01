//
//  MvColor.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import UIKit

enum MvColor:String {
    case text = "#9F9F9F"
    case accent = "#1AA7E0"
    case greenLight = "#01AECA"
    case grayLight = "#D8D8D8"
    case navy_blue = "#004C97"
    case ocean_cyan = "#007FA3"
    case green = "#00A29B"
    case purple = "#4D0388"
    case yellow = "#FFC000"
    case workSans = "#333333"
    case red = "#F76800"
    case black = "#0000009A"

    
    func convert() -> UIColor {
        return UIColor.hexStringToUIColor(hex: self.rawValue)
    }
}
