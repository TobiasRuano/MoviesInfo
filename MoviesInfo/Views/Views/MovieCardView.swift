//
//  MovieCardView.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 12/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MovieCardView: UIView {
    
    private var movieImageView: MIImageView!
    private var titleLabel: MITitleLabel!
    private var ratingLabel: MILabel!
    private var movieSummaryLabel: MILabel!
    private var infoLabel: MILabel!
    private var cardBackground: UIView!
    private var imdbLogo: UIImageView!
    private var plotTitleLabel: MILabel!
    private var genresLabel: MILabel!
    private var genreText: MILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCardView()
        setViewStyle()
        configure()
    }
    
    convenience init(title: String?, rating: Double?, summary: String?, info: String?, genres: [String], runtime: Int?) {
        self.init(frame: .zero)
        self.titleLabel.text = title ?? "N/A"
        if let ratingValue = rating {
            self.ratingLabel.text = "\(ratingValue)"
        } else {
            self.ratingLabel.text = "N/A"
        }
        self.movieSummaryLabel.text = summary ?? "N/A"
        self.infoLabel.text = info ?? "N/A"
        if !genres.isEmpty {
            genresLabel.text = getGenres(genres: genres)
        } else {
            genresLabel.text = "N/A"
        }
    }
    
    func getGenres(genres: [String]) -> String {
        return genres.joined(separator: ", ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        cardBackground.backgroundColor = .secondarySystemBackground
    }
    
    private func setupCardView() {
        cardBackground = UIView()
        cardBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardBackground)
        NSLayoutConstraint.activate([
            cardBackground.topAnchor.constraint(equalTo: topAnchor),
            cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func getMovieViewHeight() -> CGFloat {
        let height = CGFloat(195) + genresLabel.frame.height + movieSummaryLabel.frame.height
        return height
    }
    
    private func configure() {
        movieImageView = MIImageView(frame: .zero)
        cardBackground.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: -40),
            movieImageView.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        titleLabel = MITitleLabel(textColor: .label)
        titleLabel.numberOfLines = 2
        cardBackground.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -10),
        ])
        
        imdbLogo = UIImageView(image: UIImage(named: "imdb.png"))
        cardBackground.addSubview(imdbLogo)
        imdbLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imdbLogo.widthAnchor.constraint(equalToConstant: 36),
            imdbLogo.heightAnchor.constraint(equalToConstant: 18),
            imdbLogo.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            imdbLogo.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
        
        ratingLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: .label)
        ratingLabel.numberOfLines = 1
        cardBackground.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: imdbLogo.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: imdbLogo.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
        ])
        
        infoLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: .label)
        infoLabel.numberOfLines = 1
        cardBackground.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
        ])
        
        genreText = MILabel(font: UIFont.preferredFont(forTextStyle: .headline), textColor: .label)
        genreText.text = "Genres: "
        cardBackground.addSubview(genreText)
        NSLayoutConstraint.activate([
            genreText.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            genreText.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor),
            genreText.widthAnchor.constraint(equalToConstant: 70),
            genreText.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        genresLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .body), textColor: .label)
        cardBackground.addSubview(genresLabel)
        genresLabel.sizeToFit()
        genresLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            genresLabel.leadingAnchor.constraint(equalTo: genreText.trailingAnchor),
            genresLabel.topAnchor.constraint(equalTo: genreText.topAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20)
        ])
        
        plotTitleLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .headline), textColor: .label)
        plotTitleLabel.text = "Plot"
        cardBackground.addSubview(plotTitleLabel)
        NSLayoutConstraint.activate([
            plotTitleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 20),
            plotTitleLabel.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            plotTitleLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor),
            plotTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        movieSummaryLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .body), textColor: .label)
        movieSummaryLabel.numberOfLines = 0
        movieSummaryLabel.sizeToFit()
        cardBackground.addSubview(movieSummaryLabel)
        NSLayoutConstraint.activate([
            movieSummaryLabel.topAnchor.constraint(equalTo: plotTitleLabel.bottomAnchor, constant: 5),
            movieSummaryLabel.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            movieSummaryLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
        ])
        movieImageView.sizeToFit()
    }
    
    func setMovieImage(from path: String) {
        movieImageView.downloadImage(fromPath: path)
    }
}
