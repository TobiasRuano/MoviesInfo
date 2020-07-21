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
    var castView: UIView!
    var movieView: MovieCardView!
    var backdropImage: MIHeaderImageView!
    var backdropContainerView: UIView!
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var movie: Movie!
    let network = NetworkManager.shared
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    var constraint: NSLayoutConstraint!
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        configureStyle()
        configureScrollView()
        configureBackdropContainerView()
        configureBackdropImageView()
        configureContentView()
        backdropContainerViewBottomConstraint()
        configureMovieView()
        configureCastView()
        configureSimilarMoviesView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMovieViewHeightConstraint()
    }
    
    func configureStyle() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
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
    
    func configureContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func configureBackdropContainerView() {
        backdropContainerView = UIView()
        scrollView.addSubview(backdropContainerView)
        backdropContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            backdropContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backdropContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func backdropContainerViewBottomConstraint() {
        let backdropContainerViewBottom : NSLayoutConstraint!
        backdropContainerViewBottom = self.backdropContainerView.bottomAnchor.constraint(equalTo: self.contentView.topAnchor)
        backdropContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        backdropContainerViewBottom.isActive = true
    }
    
    func configureBackdropImageView() {
        backdropImage = MIHeaderImageView(frame: .zero)
        if let path = movie.backdropPath {
            backdropImage.downloadImage(fromPath: path)
        }
        backdropImage.contentMode = .scaleAspectFill
        backdropContainerView.addSubview(backdropImage)
        
        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = backdropImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true
        
        NSLayoutConstraint.activate([
            backdropImage.leadingAnchor.constraint(equalTo: backdropContainerView.leadingAnchor),
            backdropImage.trailingAnchor.constraint(equalTo: backdropContainerView.trailingAnchor),
            backdropImage.bottomAnchor.constraint(equalTo: backdropContainerView.bottomAnchor)
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
        
        constraint = movieView.heightAnchor.constraint(equalToConstant: movieView.getMovieViewHeight())
        constraint.isActive = true
        
        NSLayoutConstraint.activate([
            movieView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    private func updateMovieViewHeightConstraint() {
        let height = movieView.getMovieViewHeight()
        constraint.constant = height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func configureCastView() {
        castView = UIView()
        castView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(castView)
        
        self.add(childVC: CastCollectionViewController(movie: movie), to: self.castView)
        
        NSLayoutConstraint.activate([
            castView.topAnchor.constraint(equalTo: movieView.bottomAnchor, constant: 20),
            castView.heightAnchor.constraint(equalToConstant: 150),
            castView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            castView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configureSimilarMoviesView()  {
        similarMoviesView = UIView()
        similarMoviesView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(similarMoviesView)
        
        self.add(childVC: SimilarMoviesCollectionViewController(movie: movie), to: self.similarMoviesView)
        
        NSLayoutConstraint.activate([
            similarMoviesView.topAnchor.constraint(equalTo: castView.bottomAnchor, constant: 20),
            similarMoviesView.heightAnchor.constraint(equalToConstant: 150),
            similarMoviesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            similarMoviesView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
