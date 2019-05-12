//
//  PosterDownloader.swift
//  MovieNight
//
//  Created by davidlaiymani on 12/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit


class PosterDownloader: Operation {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let urlString = "https://image.tmdb.org/t/p/w185" + movie.posterPath
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let imageData = try! Data(contentsOf: url) // tech synchronoulsy but no pb we are in operation
        
        if self.isCancelled { // if user scroll for example, we cancel the operation so do not need to continue
            return
        }
        
        if imageData.count > 0 { // data is valid
            movie.poster = UIImage(data: imageData)
            movie.posterState = .downloaded
        } else {
            movie.posterState = .failed
        }
        
    }
}


