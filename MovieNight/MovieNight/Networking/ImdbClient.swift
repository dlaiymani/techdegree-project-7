//
//  ImdbClient.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation


class ImdbClient: APIClient {
    let session: URLSession
    let numberOfPages = 3
    
    var apiKey: String {
        return "c1129ccd979daffba7fd2a607dd6281c"
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    // Return the available IMDB Movies Genres
    func searchGenres(completion: @escaping (Result<[Genre], APIError>)  -> Void) {
        
        let endpoint = Imdb.searchGenres(apiKey: apiKey)
        let request = endpoint.request
                
        fetch(with: request, parse: { json -> [Genre] in
            guard let genres = json["genres"] as? [[String: Any]] else { return [] }
            return genres.compactMap { Genre(json: $0) }
            
        }, completion: completion)
    }
    
    // Return the available IMDB Movies Certifications (US only)
    func searchCertifications(completion: @escaping (Result<[Certification], APIError>)  -> Void) {
        
        let endpoint = Imdb.searchCertifications(apiKey: apiKey)
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [Certification] in
            guard let certifications = json["certifications"] as? [String: Any], let USCertifications = certifications["US"] as? [[String: Any]] else { return [] }
            return USCertifications.compactMap { Certification(json: $0) }
            
        }, completion: completion)
    }
    
    // Return a list of the IMDB Popular Actors. The list is limited to numberOfPages
    func searchPopularActors(completion: @escaping (Result<[Actor], APIError>)  -> Void) {
        for page in 1...numberOfPages {
            let endpoint = Imdb.searchPopularActors(apiKey: apiKey, page: String(page))
            let request = endpoint.request
            
            fetch(with: request, parse: { json -> [Actor] in
                guard let genres = json["results"] as? [[String: Any]] else { return [] }
                return genres.compactMap { Actor(json: $0) }
                
            }, completion: completion)
        }
    }
    
    
    // Return the movies corresponding to the users choices
    func discoverMovies(genres: [Genre], certifications: [Certification], popularActores: [Actor], completion: @escaping (Result<[Movie], APIError>)  -> Void) {
        
        let endpoint = Imdb.discoverMovies(apiKey: apiKey, genres: genres, certifications: certifications, actors: popularActores)
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [Movie] in
            guard let movies = json["results"] as? [[String: Any]] else { return [] }
            return movies.compactMap { Movie(json: $0) }
            
        }, completion: completion)
        
        
        
    }
    
}
