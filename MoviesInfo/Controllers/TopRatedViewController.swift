//
//  ViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    var moviesArray: [Movie] = []
    var tableView: UITableView!
    let network = NetworkManager.shared
    var pageNumber: Int = 1
    var isLoadingMovies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        configureTableview()
        requestTopRatedMovies(page: pageNumber)
    }
    
    func configureStyle() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top Rated"
    }
    
    func configureTableview() {
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 148
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
        view.addSubview(tableView)
    }
    
    func requestTopRatedMovies(page: Int) {
        isLoadingMovies = true
        let urltype = "movie/top_rated?"
        let requestURL = network.getMovieURL(type: urltype, page: page)
        network.requestMovies(type: requestURL) { [weak self] result in
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
    
    func updateUI(with movies: [Movie]) {
        moviesArray.append(contentsOf: movies)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = moviesArray.count
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.reuseID, for: indexPath) as! MoviesCell
        cell.setCell(with: moviesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfo = moviesArray[indexPath.row]
        let destVC = MovieInfoViewController()
        destVC.movie = movieInfo
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 2
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !isLoadingMovies else { return }
            pageNumber += 1
            requestTopRatedMovies(page: pageNumber)
        }
    }
}