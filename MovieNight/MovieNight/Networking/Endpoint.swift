//
//  Endpoint.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

/// A type that provides URLRequests for defined API endpoints
protocol Endpoint {
    /// Returns the base URL for the API as a string
    var base: String { get }
    /// Returns the URL path for an endpoint, as a string
    var path: String { get }
    /// Returns the URL parameters for a given endpoint as an array of URLQueryItem
    /// values
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    /// Returns an instance of URLComponents containing the base URL, path and
    /// query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    /// Returns an instance of URLRequest encapsulating the endpoint URL. This
    /// URL is obtained through the `urlComponents` object.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
     }
}

// The 4 types of requests
enum Imdb {
    case searchGenres(apiKey: String)
    case searchCertifications(apiKey: String)
    case searchPopularActors(apiKey: String, page: String)
    case discoverMovies(apiKey: String, genres: [Genre], certifications: [Certification], actors: [Actor])
}

extension Imdb: Endpoint {
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .searchGenres: return "/3/genre/movie/list"
        case .searchCertifications: return "/3/certification/movie/list"
        case .searchPopularActors: return "/3/person/popular"
        case .discoverMovies: return "/3/discover/movie"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchGenres(let apiKey), .searchCertifications(let apiKey):
            return [
                URLQueryItem(name: "api_key", value: apiKey)
            ]
        case .searchPopularActors(let apiKey, let page):
            return [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: page),

            ]
        case .discoverMovies(let apiKey, let genres, let certifications, let actors):
            var queryItemArray = [URLQueryItem(name: "api_key", value: apiKey),
                                  URLQueryItem(name: "certification_country", value: "US")]
            
            // Concatenate the parameters in the request. For example, if 3 genres, then with_genres is repeated 3 times in the request string
            queryItemArray.append(contentsOf: genres.map { URLQueryItem(name: "with_genres", value: String($0.id)) })
            queryItemArray.append(contentsOf: certifications.map { URLQueryItem(name: "certification.gte", value: String($0.name))})
            queryItemArray.append(contentsOf: actors.map { URLQueryItem(name: "with_cast", value: String($0.id))})

            return queryItemArray
        }
    }
    
    
}
