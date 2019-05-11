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
    
    var apiKey: String {
        return "c1129ccd979daffba7fd2a607dd6281c"
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    
    func searchGenres(completion: @escaping (Result<[Genre], APIError>)  -> Void) {
        
        let endpoint = Imdb.searchGenres(apiKey: apiKey)
        let request = endpoint.request
                
        fetch(with: request, parse: { json -> [Genre] in
            guard let genres = json["genres"] as? [[String: Any]] else { return [] }
            return genres.compactMap { Genre(json: $0) }
            
        }, completion: completion)
    }
    
    
    func searchCertifications(completion: @escaping (Result<[Certification], APIError>)  -> Void) {
        
        let endpoint = Imdb.searchCertifications(apiKey: apiKey)
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> [Certification] in
            guard let certifications = json["certifications"] as? [String: Any], let USCertifications = certifications["US"] as? [[String: Any]] else { return [] }
            return USCertifications.compactMap { Certification(json: $0) }
            
        }, completion: completion)
    }
}
