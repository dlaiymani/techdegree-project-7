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

enum Imdb {
    case search(apiKey: String)
}

extension Imdb: Endpoint {
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .search: return "/3/genre/movie/list"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let apiKey):
            return [
                URLQueryItem(name: "api_key", value: apiKey),
            ]
        }
    }
}
