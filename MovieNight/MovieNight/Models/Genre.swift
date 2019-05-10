//
//  Genre.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class Genre: NSObject, JSONDecodable {
    
    let id: Int
    let name: String
    
    required init?(json: [String : Any]) {
        guard let id = json["id"] as? Int, let name = json["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
        
        super.init()
    }
    
}
