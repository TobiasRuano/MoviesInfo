//
//  HomeViewModel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 07/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class HomeViewModel {
    
    var movies: Box<[Movie]> = Box([])
    var watchlist: Box<[Movie]> = Box([])
    var pageNumber: Box<Int> = Box(0)
	var isLoadingMovies: Box<Bool> = Box(false)
    var movieEndpoint: MovieInfoEndPoint!
    
    var delegate: HomeViewControllerDelegate?
	let useCase = GetMoviesUseCase()
	
    func getWatchlist() {
		watchlist.value = []
        if let data = UserDefaults.standard.value(forKey: "watchlist") as? Data {
            let copy = try? PropertyListDecoder().decode([Movie].self, from: data)
			watchlist.value = copy!
        }
    }
    
    func movieRequest(of type: MovieInfoEndPoint) {
        self.movieEndpoint = type
		self.movies.value.removeAll()
		self.pageNumber.value = 0
		self.isLoadingMovies.value = true
        self.requestMovies()
    }
    
    func addToWatchlist(movieIndexPath: Int) {
		let movieToSave = movies.value[movieIndexPath]
		if !self.watchlist.value.contains(movieToSave) {
			self.watchlist.value.append(movieToSave)
			UserDefaults.standard.set(try? PropertyListEncoder().encode(self.watchlist.value), forKey: "watchlist")
            delegate?.presentAlertWithFeedback(icon: "text.badge.plus", message: "Movie Added to Watchlist", feedbackType: .success)
        } else {
            removeFromWatchlist(indexPath: movieIndexPath)
        }
    }
    
    func removeFromWatchlist(indexPath: Int) {
		let movie = movies.value[indexPath]
		if let index = watchlist.value.firstIndex(of: movie) {
			watchlist.value.remove(at: index)
			UserDefaults.standard.set(try? PropertyListEncoder().encode(self.watchlist.value), forKey: "watchlist")
            delegate?.presentAlertWithFeedback(icon: "text.badge.minus", message: "Movie Removed from Watchlist", feedbackType: .success)
        } else {
            delegate?.presentAlertWithFeedback(icon: "x.circle.fill", message: "There was an Error Trying to Remove the Movie from your Watchlist", feedbackType: .error)
        }
    }
    
    func requestMovies() {
		self.pageNumber.value += 1
		useCase.execute(listType: movieEndpoint, page: pageNumber.value) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let movies):
				self.movies.value.append(contentsOf: movies)
			case .failure(let error):
				print("\(error): \(error.rawValue)")
			}
			self.isLoadingMovies.value = false
		}
    }

	func watchlistContains(movieIndexPath: IndexPath) -> Bool {
		let movie = movies.value[movieIndexPath.row]
		return watchlist.value.contains(movie)
	}
}
