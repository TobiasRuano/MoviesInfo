//
//  MovieInfoViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    var similarMoviesView: UIView!
    var movieView: MovieCardView!
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var movie: Movie!
    let network = NetworkManager.shared
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        configureStyle()
        configureScrollView()
        configureContenView()
        configureMovieView()
        configureSimilarMoviesView()
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
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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
        contentView.addSubview(movieView)
        
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            movieView.heightAnchor.constraint(equalToConstant: 300),
            movieView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
            movieView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configureSimilarMoviesView()  {
        similarMoviesView = UIView()
        similarMoviesView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(similarMoviesView)
        
        self.add(childVC: ImageCollectionViewController(movie: movie), to: self.similarMoviesView)
        
        NSLayoutConstraint.activate([
            similarMoviesView.topAnchor.constraint(equalTo: movieView.bottomAnchor, constant: 20),
            similarMoviesView.heightAnchor.constraint(equalToConstant: 200),
            similarMoviesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            similarMoviesView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            similarMoviesView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
