//
//  MovieTableViewDataSource.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import Foundation
import UIKit

class MovieTableViewDataSource<CELL : UITableViewCell,T> : NSObject, UITableViewDataSource {
    
    private var cellIdentifier : String!
    private var items : [SubCategoryModel]!
    var configureCell : (CELL, MoviesModel) -> () = {_,_ in }
    
    init(cellIdentifier : String, items : [SubCategoryModel], configureCell : @escaping (CELL, MoviesModel) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        let item = self.items[indexPath.section].list[indexPath.row]
        cell.tag = indexPath.section
        self.configureCell(cell, item)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    

}
