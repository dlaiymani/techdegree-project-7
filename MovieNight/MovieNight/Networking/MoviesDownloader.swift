//
//  MoviesDownloader.swift
//  MovieNight
//
//  Created by davidlaiymani on 14/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation



class MovieDownloader: Operation {
    
    var movies: [Movie]
    var genres = [Genre]()
    var certifications = [Certification]()
    var popularActors = [Actor]()
    
    let client: ImdbClient
    
    init(genres: [Genre], certifications: [Certification],  actors: [Actor], client: ImdbClient) {
        self.genres = genres
        self.certifications = certifications
        self.popularActors = actors
        self.movies = [Movie]()
        self.client = client
        super.init()
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _finished = false // backing property
    
    override private(set) var isFinished: Bool {
        get {
            return _finished // return isFinished is impossible
        }
        
        set {
            willChangeValue(forKey: "isFinished") // Notify the operation queue
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    
    private var _executing = false
    
    override private(set) var isExecuting: Bool {
        get {
            return _executing // return isFinished is impossible
        }
        
        set {
            willChangeValue(forKey: "isExecuting") // Notify the operation queue
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        client.discoverMovies(genres: genres, certifications: certifications, popularActores: popularActors) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                print(self?.movies)
                self?.isExecuting = false
                self?.isFinished = true
            case .failure(let error):
                //let alertError = AlertError(error: error, on: self)
                //alertError.displayAlert()
                print(error)
                self?.isExecuting = false
                self?.isFinished = true
            }
        }
    }
}
