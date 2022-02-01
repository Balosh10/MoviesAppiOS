//
//  MovieCollectionViewDelegate.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 30/01/22.
//

import Foundation
import UIKit

class MovieCollectionViewDelegate<CELL : UICollectionViewCell,T> : NSObject, UICollectionViewDelegate {
    
    private var cellIdentifier : String!
    private var items : [T]?
    var configureCell : (CELL, T?) -> () = {_,_ in }
    
    
    init(cellIdentifier : String, items : [T]?, configureCell : @escaping (CELL, T?) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CELL
        let item = self.items?[indexPath.row]
        self.configureCell(cell, item)
    }
}

