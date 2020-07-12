//
//  MovieModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 03/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

struct Movie: Codable, Hashable {
    
    //MARK: - Properties
    var title: String
    var overview: String
    var releaseDate: String
    var genreIds: [Int]
    var id: Int
    var posterPath: String
    var voteAverage: Double
    
    //MARK: - Methods
    func getImage() -> Data {
        let network = NetworkManager.shared
        let data = network.retrieveImage(posterPath: posterPath)
        return data
    }
}
