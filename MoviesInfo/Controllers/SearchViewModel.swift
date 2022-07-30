//
//  SearchViewModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 30/07/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation

class SearchViewModel {
	let network = NetworkManager.shared
	var searchedMovies: [Movie] = []
	var watchlist: [Movie] = []
	var page = 1
	var hasMoreMovies = true
	var isloadingMoreMovies = false
	var isSearching = false
	var query = ""

	let useCase = SearchMoviesUseCase(repo: MoviesRepositoryImplementation(dataSource: MoviesAPIImpl()))

	func getWatchlist() {
		if let data = UserDefaults.standard.value(forKey: "watchlist") as? Data {
			let copy = try? PropertyListDecoder().decode([Movie].self, from: data)
			watchlist = copy!
		}
	}

	func watchlistContains(movieIndexPath: IndexPath) -> Bool {
		let movie = searchedMovies[movieIndexPath.row]
		return watchlist.contains(movie)
	}
}
