//
//  NetworkModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 04/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

enum requestType {
    case user
    case movie
    case authorizeUser
    case requestToken
}

class NetworkManager {
    
    public static let shared = NetworkManager()
    let baseURL = "https://api.themoviedb.org/3/"
    let avatarBaseURL = "https://secure.gravatar.com/avatar/"
    let apiKey = "de5b247a6e6b7609efefe1a38f215388"
    var sessionID = ""
    var token = ""
    
    let cache = NSCache<NSString, UIImage>()
    
//    func requestAuthToken() {
//        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)")! as URL
//        apiCall(url: url, type: .requestToken)
//    }
    
    //    private func authUser() {
    //        let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)")! as URL
    //        apiCall(url: url, type: .authorizeUser)
    //    }
    
//    func requestUserAccountInfo() {
//        let url = URL(string: "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionID)")! as URL
//        apiCall(url: url, type: .user)
//    }
    
//    func requestOtherUserInfo() {
//        #warning("Implement")
//    }
    
//    func retriveSimilarMovies(movieID: Int) {
//        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(movieID)/similar?api_key=\(apiKey)&language=en-US&page=1")! as URL
//        apiCall(url: url, type: .movie)
//    }
    
    func retrieveImage(posterPath: String) -> Data {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        var image = Data()
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: url!) {
                image = data
            }
        }
        return image
    }
    
    func getMovies(type: String, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void) {
        let apiKeyPart = "api_key=\(apiKey)"
        let endpoint = baseURL + "\(type)\(apiKeyPart)&language=en-US&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
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
                let movies = try decoder.decode([Movie].self, from: data, keyPath: "results")
                print(movies)
                completed(.success(movies))
            } catch {
                completed(.failure(.invalidData))
            }
        })
        task.resume()
    }
    
//    func getRequestToken(dict: Dictionary<String, Any>) {
//        if dict["success"] as! Bool == true {
//            token = dict["request_token"] as! String
//        }
//    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
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
