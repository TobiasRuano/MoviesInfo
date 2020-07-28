//
//  Date+Ext.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 16/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import Foundation

extension Date {
    func convertToDayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}
