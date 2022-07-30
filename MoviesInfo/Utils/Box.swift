//
//  Box.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 30/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

final class Box<T> {

	typealias Listener = (T) -> Void
	var listener: Listener?

	var value: T {
		didSet {
			listener?(value)
		}
	}

	init(_ value: T) {
		self.value = value
	}

	func bind(listener: Listener?) {
		self.listener = listener
		listener?(value)
	}

}
