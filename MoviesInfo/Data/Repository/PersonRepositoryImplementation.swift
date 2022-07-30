//
//  PersonRepositoryImplementation.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

struct PersonRepositoryImplementation: PersonRepository {

	var dataSource: PersonDataSource

	func getPerson(personID: Int, completion: @escaping (Result<Person, MIError>) -> Void) {
		let url = NetworkManager.shared.getPersonDetailsURL(personID: personID)
		dataSource.getPerson(url: url) { result in
			switch result {
			case .success(let person):
				completion(.success(person))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
