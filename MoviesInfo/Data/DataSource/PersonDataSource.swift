//
//  PersonDataSource.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol PersonDataSource {
	func getPerson(url: String, completed: @escaping (Result<Person, MIError>) -> Void)
}
