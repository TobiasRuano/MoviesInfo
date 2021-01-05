//
//  AccountModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 30/07/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var avatar: gravatar
    var id: Int
}

struct gravatar: Codable {
    var hash: String
}
