//
//  MovieTableViewDelegate.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import Foundation
import UIKit

class MovieTableViewDelegate<CELL:UITableViewCell,T> : NSObject, UITableViewDelegate {
    
    private var storedOffsets = [Int: CGFloat]()
    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let header = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CELL
        let item = self.items[section]
        self.configureCell(header, item)
        view.addSubview(header)
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

       guard let tableViewCell = cell as? MovieTableViewCell else { return }
       tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
   }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? MovieTableViewCell else { return }
        self.storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        
    }
}
