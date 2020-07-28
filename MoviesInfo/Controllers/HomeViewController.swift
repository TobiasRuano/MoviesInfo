//
//  HomeViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 21/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private var movies: [Movie] = []
    private var watchlist: [Movie] = []
    
    private var movieEndpoint: MovieInfoEndPoint!
    
    private let network = NetworkManager.shared
    private var pageNumber: Int = 1
    private var isLoadingMovies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        configureNavigationBar()
        newRequest(type: .nowPlaying)
    }
    
    private func configureNavigationBar() {
        let image = UIImage(systemName: "ellipsis.circle")
        let action = #selector(changeEndPoint(sender:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
    }
    
    @objc private func changeEndPoint(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "What movies you would like to see?", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Now Playing", style: .default, handler: { (UIAlertAction) in
            self.newRequest(type: .nowPlaying)
        }))
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default, handler: { (UIAlertAction) in
            self.newRequest(type: .upcoming)
        }))
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default, handler: { (UIAlertAction) in
            self.newRequest(type: .topRated)
        }))
        alert.addAction(UIAlertAction(title: "Popular", style: .default, handler: { (UIAlertAction) in
            self.newRequest(type: .popular)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func newRequest(type: MovieInfoEndPoint) {
        self.movieEndpoint = type
        self.requestMovies(page: 1)
        self.pageNumber = 1
        self.movies.removeAll()
        switch type {
        case .nowPlaying:
            self.title = "Now Playing"
        case .popular:
            self.title = "Popular"
        case .topRated:
            self.title = "Top Rated"
        case .upcoming:
            self.title = "Upcoming"
        }
    }
    
    private func configureTableView() {
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.reuseID, for: indexPath) as! MoviesCell
        cell.setCell(with: movies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfo = movies[indexPath.row]
        let destVC = MovieInfoViewController()
        destVC.movie = movieInfo
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let AddAction = UIContextualAction(style: .normal, title:  "Add to Watchlist", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if !self.watchlist.contains(self.movies[indexPath.row]) {
                self.watchlist.append(self.movies[indexPath.row])
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.watchlist), forKey: "watchlist")
            }
            success(true)
        })
        AddAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [AddAction])
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 2
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !isLoadingMovies else { return }
            isLoadingMovies = true
            pageNumber += 1
            requestMovies(page: pageNumber)
        }
    }
    
    func requestMovies(page: Int) {
        let requestURL = network.getMoviesURL(endpoint: movieEndpoint, page: page)
        network.fetchMovies(type: requestURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                print("\(error): \(error.rawValue)")
            }
            self.isLoadingMovies = false
        }
    }
    
    private func updateUI(with movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
