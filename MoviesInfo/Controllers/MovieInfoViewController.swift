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
    var scrollView: UIScrollView!
    var contenView: UIView!
    
    var isLoadingMovies = false
    var movie: Movie!
    var relatedMovies: [Movie] = []
    let network = NetworkManager.shared
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        configureStyle()
        configureScrollView()
        configureContenView()
        configureMovieView()
        configureCollectionView()
        configureDataSource()
        requestSimilarMovies(page: 1)
    }
    
    func configureStyle() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func configureContenView() {
        contenView = UIView()
        contenView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contenView)
        
        NSLayoutConstraint.activate([
            contenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contenView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contenView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contenView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureMovieView() {
        let date = movie.releaseDate?.convertToDisplayFormat() ?? "N/A"
        movieView = MovieCardView(title: movie.title, rating: movie.voteAverage, summary: movie.overview, info: date)
        if let path = movie.posterPath {
            movieView.setMovieImage(from: path)
        } else {
            movieView.setMovieImage(from: "path")
        }
        contenView.addSubview(movieView)
        
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: contenView.safeAreaLayoutGuide.topAnchor, constant: 20),
            movieView.heightAnchor.constraint(equalToConstant: 300),
            movieView.widthAnchor.constraint(equalTo: contenView.widthAnchor, constant: -40),
            movieView.centerXAnchor.constraint(equalTo: contenView.centerXAnchor)
        ])
    }
    
    func configureCollectionView()  {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneLineFlowLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.reuseID)
        contenView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: movieView.bottomAnchor, constant: 20),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.bottomAnchor.constraint(equalTo: contenView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: contenView.widthAnchor),
            collectionView.centerXAnchor.constraint(equalTo: contenView.centerXAnchor)
        ])
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.reuseID, for: indexPath) as! SimilarMovieCell
            cell.setCell(with: movie)
            return cell
        })
    }
    
    func requestSimilarMovies(page: Int) {
        isLoadingMovies = true
        let urltype = "movie/\(movie.id)/similar?"
        let requestURL = network.getMovieURL(type: urltype, page: page)
        network.fetchMovies(type: requestURL) { [weak self] result in
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
                self.scrollView.addSubview(emptyUIView)
                emptyUIView.frame = self.collectionView.frame
            } else {
                self.updateData(on: self.relatedMovies)
            }
        }
    }
    
    func updateData(on followers: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
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
