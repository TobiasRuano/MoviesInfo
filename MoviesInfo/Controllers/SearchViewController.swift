//
//  SearchViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let network = NetworkManager.shared
    var collectionView: UICollectionView!
    var searchedMovies: [Movie] = []
    var page = 1
    var hasMoreMovies = true
    var isloadingMoreMovies = false
    var isSearching = false
    var query = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
        configureSearchController()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .interactive
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search a Movie"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func searchForMovies(query: String, page: Int) {
        let searchURL = network.getSearchURL(query: query, page: page)
        network.fetchMovies(type: searchURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                self.presentEmptyStateViewOnMainThread(message: error.rawValue)
            }
        }
    }
    
    func updateUI(with movies: [Movie]) {
        if movies.count < 20 {
            self.hasMoreMovies = false
        }
        if !isloadingMoreMovies {
            searchedMovies.removeAll()
        }
        isloadingMoreMovies = false
        searchedMovies.append(contentsOf: movies)
        if self.searchedMovies.isEmpty {
            presentEmptyStateViewOnMainThread(message: "Unable to find titles related to your search.")
        } else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func presentEmptyStateViewOnMainThread(message: String) {
        DispatchQueue.main.async {
            let emptyUIView = MIEmptyStateView(message: message)
            emptyUIView.tag = 1001
            self.view.addSubview(emptyUIView)
            emptyUIView.frame = self.collectionView.frame
            emptyUIView.backgroundColor = .secondarySystemBackground
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.reuseID, for: indexPath) as! SearchMovieCell
        cell.set(movie: self.searchedMovies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInfo = searchedMovies[indexPath.row]
        let destVC = MovieInfoViewController()
        destVC.movie = movieInfo
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 4
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreMovies else { return }
            page += 1
            isloadingMoreMovies = true
            searchForMovies(query: query, page: page)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let filter = searchBar.text, !filter.isEmpty else {
            self.resignFirstResponder()
            return
        }
        
        if let filteredString = filter.stringByAddingPercentEncodingForRFC3986() {
            self.view.viewWithTag(1001)?.removeFromSuperview()
            isSearching = true
            searchForMovies(query: filteredString, page: 1)
            query = filter
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchedMovies.removeAll()
        collectionView.reloadData()
        self.view.viewWithTag(1001)?.removeFromSuperview()
        self.resignFirstResponder()
    }
}
