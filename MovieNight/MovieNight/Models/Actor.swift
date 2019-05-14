//
//  Actor.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// The Actor type
class Actor: NSObject, Item {
    
    let id: Int
    let name: String
    
    required init?(json: [String : Any]) {
        guard let id = json["id"] as? Int, let name = json["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
        
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? Actor)?.id
    }
}
