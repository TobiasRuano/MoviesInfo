//
//  SearchViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var collectionView: UICollectionView!

	private var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Search"
        configureSearchController()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		viewModel.getWatchlist()
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
		viewModel.useCase.execute(query: query, page: page) { [weak self] result in
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
            viewModel.hasMoreMovies = false
        }
		if !viewModel.isloadingMoreMovies {
			viewModel.searchedMovies.removeAll()
        }
		viewModel.isloadingMoreMovies = false
		viewModel.searchedMovies.append(contentsOf: movies)
		if viewModel.searchedMovies.isEmpty {
            presentEmptyStateViewOnMainThread(message: "Unable to find titles related to your search.")
        } else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
		viewModel.isSearching = false
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
		return viewModel.searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.reuseID, for: indexPath) as! SearchMovieCell
		cell.set(movie: viewModel.searchedMovies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = MovieInfoViewController()
        destVC.movie = viewModel.searchedMovies[indexPath.row]
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let addToWatchlist = UIAction(title: "Add to Watchlist", image: UIImage(systemName: "plus")) { action in
				if !self.viewModel.watchlist.contains(self.viewModel.searchedMovies[indexPath.item]) {
					self.viewModel.watchlist.append(self.viewModel.searchedMovies[indexPath.item])
					UserDefaults.standard.set(try? PropertyListEncoder().encode(self.viewModel.watchlist), forKey: "watchlist")
                }
            }
            return UIMenu(title: "", children: [addToWatchlist])
        }
        return configuration
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 4
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
			guard viewModel.hasMoreMovies, !viewModel.isSearching else { return }
			viewModel.page += 1
			viewModel.isloadingMoreMovies = true
			searchForMovies(query: viewModel.query, page: viewModel.page)
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
			viewModel.query = filteredString
            self.view.viewWithTag(1001)?.removeFromSuperview()
			viewModel.isSearching = true
			searchForMovies(query: viewModel.query, page: 1)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		viewModel.isSearching = false
		viewModel.searchedMovies.removeAll()
        collectionView.reloadData()
        self.view.viewWithTag(1001)?.removeFromSuperview()
        self.resignFirstResponder()
    }
}
