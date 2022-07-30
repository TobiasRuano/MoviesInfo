//
//  SearchMoviesuseCase.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol SearchMovies {
	func execute(query: String, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void)
}

struct SearchMoviesUseCase: SearchMovies {

	let repo: MoviesRepositoryImplementation

	func execute(query: String, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void) {
		repo.searchMovies(query: query, page: page) { result in
			switch result {
			case.success(let movies):
				completed(.success(movies))
			case .failure(let error):
				completed(.failure(error))
			}
		}
	}
}
