//
//  UIView+Extensions.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 30/01/22.
//

import Foundation
import UIKit

extension UIView {
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
    
    func setRadiusProfile(){
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
    }
    
    func applyGradient(width:CGFloat, height:CGFloat) -> CAGradientLayer {
       let l = CAGradientLayer()
       l.frame = CGRect(x: 0, y: 0, width: width, height: height)
        l.colors = [UIColor.black .cgColor,
                    UIColor.gray.cgColor]
      //  gradientLayer.type = .axial
       l.startPoint = CGPoint(x: 0, y: 0.5)
       l.endPoint = CGPoint(x: 1, y: 0.5)
       layer.insertSublayer(l, at: 0)
       return l
   }
    
}
