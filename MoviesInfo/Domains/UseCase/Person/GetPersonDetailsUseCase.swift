//
//  GetPersonDetailsUseCase.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 29/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

protocol GetPersonDetails {
	func execute(personID: Int, completed: @escaping (Result<Person, MIError>) -> Void)
}

struct GetPersonDetailsUseCase: GetPersonDetails {
	let repo = PersonRepositoryImplementation(dataSource: PersonAPIImpl())

	func execute(personID: Int, completed: @escaping (Result<Person, MIError>) -> Void) {
		repo.getPerson(personID: personID) { result in
			switch result {
			case.success(let person):
				completed(.success(person))
			case .failure(let error):
				completed(.failure(error))
			}
		}
	}
}
