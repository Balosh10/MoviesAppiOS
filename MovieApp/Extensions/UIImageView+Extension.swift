//
//  UIImageView+Extension.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 30/01/22.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(url: URL) {
       DispatchQueue.global().async { [weak self] in
           if let data = try? Data(contentsOf: url) {
               if let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self?.image = image
                   }
               }
           }
       }
   }
    
}
