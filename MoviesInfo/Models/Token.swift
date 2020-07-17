//
//  Token.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import Foundation

struct Token: Codable, Hashable {
    var success: Bool?
    var expiresAt: String?
    var requestToken: String?
}
