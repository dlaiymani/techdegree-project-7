//
//  Movie.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit

// Used by operation queues when downloading a poster
enum MoviePosterState {
    case placeholder
    case downloaded
    case failed
}

// The type
class Movie: NSObject, Item {
    
    let id: Int
    let voteAverage: Double
    let posterPath: String
    let overview: String
    let name: String
    var poster: UIImage?
    var posterState = MoviePosterState.placeholder
    
    required init?(json: [String : Any]) {
        guard let id = json["id"] as? Int,
            let name = json["title"] as? String,
            let voteAverage = json["vote_average"] as? Double,
            let posterPath = json["poster_path"] as? String,
            let overview = json["overview"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.overview = overview
        
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? Movie)?.id
    }
    
}
