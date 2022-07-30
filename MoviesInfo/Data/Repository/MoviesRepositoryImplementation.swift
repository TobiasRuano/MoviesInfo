//
//  MoviesRepositoryImplementation.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

enum MovieInfoEndPoint: String, CaseIterable {
	case topRated = "movie/top_rated?"
	case nowPlaying = "movie/now_playing?"
	case upcoming = "movie/upcoming?"
	case popular = "movie/popular?"
}

struct MoviesRepositoryImplementation: MoviesRepository {
    
    var dataSource: MoviesDataSource
    
	func getMovies(listType: MovieInfoEndPoint, page: Int, completion: @escaping (Result<[Movie], MIError>) -> Void) {
		let url = NetworkManager.shared.getMoviesURL(endpoint: listType, page: page)
		dataSource.getMovies(url: url, page: page) { result in
			switch result {
			case .success(let movies):
				completion(.success(movies))
			case .failure(let error):
				completion(.failure(error))
			}
		}
    }

	func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], MIError>) -> Void) {
		let url = NetworkManager.shared.getSearchURL(query: query, page: page)
		dataSource.getMovies(url: url, page: page) { result in
			switch result {
			case .success(let movies):
				completion(.success(movies))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
