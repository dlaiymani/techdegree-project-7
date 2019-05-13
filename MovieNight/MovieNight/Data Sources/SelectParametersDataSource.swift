//
//  SelectParametersDataSource.swift
//  MovieNight
//
//  Created by davidlaiymani on 11/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit

class SelectParametersDataSource: NSObject, UITableViewDataSource {
    private var data: [Item]
    
    init(data: [Item]) {
        self.data = data
        super.init()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        let item = object(at: indexPath)
        
        cell.textLabel?.text = item.name
        cell.accessoryType = .none
        
        return cell
    }
    
    
    
    // MARK: Helpers
    
    func update(_ object: Item, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [Item]) {
        self.data = data
    }
    
    func appendData(_ data: [Item]) {
        self.data.append(contentsOf: data)
    }
    
    func object(at indexPath: IndexPath) -> Item {
        return data[indexPath.row]
    }
}
