//
//  GenreManager.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 11/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import Foundation

class GenreManager {
    public static let shared = GenreManager()
    
    func getGenres(ids: [Int]) -> [String] {
        var result = [String]()
        if let path = Bundle.main.path(forResource: "Genres", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! Dictionary<String, AnyObject>
                
                guard let jsonArray = jsonResult["genres"] as? [[String: Any]] else {
                    return result
                }
                for genre in ids {
                    var counter = 0
                    while counter < jsonArray.count  && jsonArray[counter]["id"] as! Int != genre {
                        counter = counter + 1
                    }
                    result.append(jsonArray[counter]["name"] as! String)
                    counter = 0
                }
            } catch {
                print("Unable to get Genre: \(error.localizedDescription)")
                result.append("nil")
            }
        }
        return result
    }
}
