//
//  MovieInfoViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    var movieView: MovieCardView!
    
    var isLoadingMovies = false
    var movie: Movie!
    var relatedMovies: [Movie] = []
    let network = NetworkManager.shared
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        self.setupCollectionView()
        movieView = MovieCardView(title: movie.title, rating: movie.voteAverage, summary: movie.overview, info: movie.releaseDate)
        view.addSubview(movieView)
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            movieView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            movieView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20)
        ])
        if let path = movie.posterPath {
            movieView.setMovieImage(from: path)
        } else {
            movieView.setMovieImage(from: "path")
        }
        configureDataSource()
        requestSimilarMovies(page: 1)
    }
    
    func requestSimilarMovies(page: Int) {
        isLoadingMovies = true
        let urltype = "movie/\(movie.id)/similar?"
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
        relatedMovies.append(contentsOf: movies)
        DispatchQueue.main.async {
            if self.relatedMovies.isEmpty {
                let emptyUIView = MIEmptyStateView(message: "Unable to find titles related to this movie.")
                self.view.addSubview(emptyUIView)
                emptyUIView.frame = self.collectionView.frame
            } else {
                self.updateData(on: self.relatedMovies)
            }
        }
    }
    
    private func setupCollectionView()  {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneLineFlowLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseID)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseID, for: indexPath) as! CustomCollectionViewCell
            cell.setCell(with: movie)
            return cell
        })
    }
    
    func updateData(on followers: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension MovieInfoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = MovieInfoViewController()
        destVC.movie = relatedMovies[indexPath.row]
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
