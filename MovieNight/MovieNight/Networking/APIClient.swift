//
//  APIClient.swift
//  MovieNight
//
//  Created by davidlaiymani on 10/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

import Foundation

// Possible errors for API requests
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case noMatch
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "No Match"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .noMatch: return "Sorry, No Match"
        }
    }
}

// The APIClient protocol delivers a set of methods allowing asynchronous API requests
protocol APIClient {
    var session: URLSession { get }
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) ->T?, completion: @escaping (Result<T, APIError>) -> Void)
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) ->[T], completion: @escaping (Result<[T], APIError>) -> Void)
    
}

extension APIClient {
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, APIError?) -> Void
    
    // Send a request a receive a JSON object
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
    
    // Send a request a parse the return JSON into an object of type T
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) ->T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = jsonTask(with: request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                if let value = parse(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    // Send a request a parse the return JSON into an object of type [T]
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) ->[T], completion: @escaping (Result<[T], APIError>) -> Void) {
        let task = jsonTask(with: request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                let value = parse(json)
                
                if !value.isEmpty {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
