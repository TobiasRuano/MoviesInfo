//
//  LoginUseCase.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol GetMovies {
	func execute(listType: MovieInfoEndPoint, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void)
}

struct GetMoviesUseCase: GetMovies {
    var repo: MoviesRepository
    
	func execute(listType: MovieInfoEndPoint, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void) {
		repo.getMovies(listType: listType, page: page) { result in
			switch result {
			case.success(let movies):
				completed(.success(movies))
			case.failure(let error):
				completed(.failure(error))
			}
		}
    }
}
