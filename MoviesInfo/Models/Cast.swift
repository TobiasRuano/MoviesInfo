//
//  Cast.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 17/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import Foundation

struct Cast: Codable, Hashable {
    let id: Int
    let name: String?
    let character: String?
    let order: Int?
    let profilePath: String?
}
