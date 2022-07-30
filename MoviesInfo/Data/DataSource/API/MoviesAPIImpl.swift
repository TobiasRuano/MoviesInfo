//
//  OkPagosUserAPIImpl.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 30/06/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK
}

struct MoviesAPIImpl: MoviesDataSource {
	func getMovies(url: String, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void) {
		NetworkManager.shared.fetchData(urlString: url, castType: [Movie].self, keyPath: "results") { result in
			switch result {
			case .success(let movies):
				completed(.success(movies))
			case .failure(let error):
				completed(.failure(error))
			}
		}
	}
}
