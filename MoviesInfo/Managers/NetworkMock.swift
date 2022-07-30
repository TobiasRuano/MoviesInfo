//
//  NetworkMock.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

protocol NetworkProtocol {
    func getSearchURL(query: String, page: Int) -> String
    func getMoviesURL(endpoint: MovieInfoEndPoint, page: Int) -> String
    func getPersonDetailsURL(personID: Int) -> String
    func searchMovieURL(type: String, page: Int) -> String
    func fetchData<T: Decodable>(urlString: String, castType: T.Type, keyPath: String?, completed: @escaping (Result<T, MIError>) -> Void)
    func fetchImage(from urlString: String, completed: @escaping (Result<UIImage, MIError>) -> Void)
}

class NetworkMock: NetworkProtocol {
    
    public static let shared = NetworkMock()
    let baseURL = "https://api.themoviedb.org/3/"
    let apiKey = "de5b247a6e6b7609efefe1a38f215388"
    
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
        
        completed(.success([Movie(title: "Test title", overview: "Some overview", releaseDate: "01/01/2022", genreIds: [1, 10, 11], id: 1, posterPath: "posterPath", backdropPath: "backdropPath", voteAverage: 7.8, runtime: 120)] as! T))
    }
    
    func fetchImage(from urlString: String, completed: @escaping (Result<UIImage, MIError>) -> Void) {
        guard let _ = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        completed(.success(UIImage()))
    }
}
