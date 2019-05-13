//
//  Item.swift
//  MovieNight
//
//  Created by davidlaiymani on 11/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation


protocol Item: NSObject, JSONDecodable {
    var name: String { get }
}


enum ParemeterType: String {
    case genre = "Genres"
    case certification = "Certifications"
    case popularActors = "Popular Actors"
}
