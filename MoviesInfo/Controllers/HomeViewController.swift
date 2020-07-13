//
//  ViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    var moviesArray: [Movie] = []
    var tableView: UITableView!
    let network = NetworkManager.shared
    var pageNumber: Int = 1
    var isLoadingMovies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "Top Rated"
        configureTableview()
        requestTopRatedMovies(page: pageNumber)
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
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
        view.addSubview(tableView)
    }
    
    func requestTopRatedMovies(page: Int) {
        isLoadingMovies = true
        let urltype = "movie/top_rated?"
        network.getMovies(type: urltype, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                print(error)
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

    //MARK: - TableView delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        present(destVC, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !isLoadingMovies else { return }
            pageNumber += 1
            requestTopRatedMovies(page: pageNumber)
        }
    }
}

