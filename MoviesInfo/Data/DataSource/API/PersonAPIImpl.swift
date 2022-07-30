//
//  PersonAPIImpl.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

struct PersonAPIImpl: PersonDataSource {
	func getPerson(url: String, completed: @escaping (Result<Person, MIError>) -> Void) {
		NetworkManager.shared.fetchData(urlString: url, castType: Person.self) { result in
			switch result {
			case .success(let person):
				completed(.success(person))
			case .failure(let error):
				completed(.failure(error))
			}
		}
	}
}
