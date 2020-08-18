//
//  MovieModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 03/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation

struct Movie: Codable, Hashable {
    var title: String?
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int]?
    var id: Int
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double?
    var runtime: Int?
}
