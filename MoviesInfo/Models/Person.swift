//
//  Person.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 24/11/2021.
//  Copyright © 2021 Tobias Ruano. All rights reserved.
//

import Foundation

struct Person: Codable, Hashable {
    let name: String
    let id: Int
    let birthday: String?
    let biography: String
    let placeOfBirth: String?
    let profilePath: String?
}
