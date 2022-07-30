//
//  OkPagosUserDataSource.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol MoviesDataSource {

	func getMovies(url: String, page: Int, completed: @escaping (Result<[Movie], MIError>) -> Void)
    
}
