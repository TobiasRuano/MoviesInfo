//
//  MIError.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 11/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import Foundation

enum MIError: String, Error {
    case invalidUrl = "This url is not valid."
    case unableToComplete = "Unable to complete your request. Plese check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data recieved from the server was invalid."
    case unableToParseData = "The data given does not match the Model."
    case unableToGetImage = "The you are trying to load is not an image"
}
