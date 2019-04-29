//
//  TableViewDataSource.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation
import UIKit

// Altough this could look a little too much, a generic data source is a really powerful tool. We can use it for other table view controllers without retyping every function inside the datasource protocol and it automatically will adjust to the type we are injecting.
// We are only adding the restriction that "CellType" must be a class that inherit from UITableViewCell.
class TableViewDataSource<CellType,ViewModel>: NSObject, UITableViewDataSource where CellType: UITableViewCell {
    // Identifier of the cell, the items that will contain, and a closure that will help us to trigger and configure our cell
    let cellIdentifier: String
    var items: [ViewModel]
    let configureCell: (CellType, ViewModel) -> ()
    
    init(cellIdentifier: String, items: [ViewModel], configureCell: @escaping (CellType,ViewModel) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    // Just in case we were doing any modification to the items, we need to update them
    func updateItems(_ items: [ViewModel]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("Cell with identifier \(self.cellIdentifier) not found")
        }
        
        // Here we trigger the closure to configure our cell
        let vm = self.items[indexPath.row]
        self.configureCell(cell, vm)
        return cell
        
    }
    
}

