//
//  Certification.swift
//  MovieNight
//
//  Created by davidlaiymani on 11/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// The Movie Certification type
class Certification: NSObject, Item {
    
    let name: String
    
    required init?(json: [String : Any]) {
        guard let certification = json["certification"] as? String else { return nil }
        
        self.name = certification
        
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return name == (object as? Certification)?.name
    }
    
}
