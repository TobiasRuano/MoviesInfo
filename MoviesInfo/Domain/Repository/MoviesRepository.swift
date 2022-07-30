//
//  MoviesRepository.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol MoviesRepository {
	func getMovies(listType: MovieInfoEndPoint, page: Int, completion: @escaping (Result<[Movie], MIError>) -> Void)
	func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], MIError>) -> Void)
}
