//
//  NetworkModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 04/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class NetworkManager {
    
    public static let shared = NetworkManager()
    let baseURL = "https://api.themoviedb.org/3/"
    let avatarBaseURL = "https://secure.gravatar.com/avatar/"
    let apiKey = "de5b247a6e6b7609efefe1a38f215388"
    
    let cache = NSCache<NSString, UIImage>()
    
    func getSearchURL(query: String, page: Int) -> String {
        let apiKeyPart = "api_key=\(apiKey)"
        let endpoint = baseURL + "search/movie?\(apiKeyPart)&language=en-US&query=\(query)&page=\(page)&include_adult=false"
        return endpoint
    }
    
    func getMoviesURL(endpoint: MovieInfoEndPoint, page: Int) -> String {
        let apiKeyPart = "api_key=\(apiKey)"
        let endpoint = baseURL + "\(endpoint.rawValue)\(apiKeyPart)&language=en-US&page=\(page)"
        return endpoint
    }
    
    func getPersonDetailsURL(personID: Int) -> String {
        let apiKeyPart = "api_key=\(apiKey)"
        let endpoint = baseURL + "person/\(personID)?\(apiKeyPart)&language=en-US"
        print(endpoint)
        return endpoint
    }
    
    func searchMovieURL(type: String, page: Int) -> String {
        let apiKeyPart = "api_key=\(apiKey)"
        let endpoint = baseURL + "\(type)\(apiKeyPart)&language=en-US&page=\(page)"
        return endpoint
    }
    
    func fetchData<T: Decodable>(urlString: String, castType: T.Type, keyPath: String? = nil, completed: @escaping (Result<T, MIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let keypath = keyPath {
                    let decodedData = try decoder.decode(T.self, from: data, keyPath: keypath)
                    completed(.success(decodedData))
                } else {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completed(.success(decodedData))
                }
            } catch {
                completed(.failure(.unableToParseData))
            }
        })
        task.resume()
    }
    
    func fetchImage(from urlString: String, completed: @escaping (Result<UIImage, MIError>) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            if let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: cacheKey)
                completed(.success(image))
            } else {
                completed(.failure(.unableToGetImage))
            }
        }
        task.resume()
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}
