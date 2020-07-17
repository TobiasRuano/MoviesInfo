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
    private var titleLabel: MILabel!
    private var ratingLabel: MILabel!
    private var movieSummaryLabel: MILabel!
    private var infoLabel: MILabel!
    private var cardBackground: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCardView()
        setViewStyle()
        configure()
    }
    
    convenience init(title: String?, rating: Double?, summary: String?, info: String?) {
        self.init(frame: .zero)
        self.titleLabel.text = title ?? "N/A"
        if let ratingValue = rating {
            self.ratingLabel.text = "IMDB Rating: \(ratingValue)"
        } else {
            self.ratingLabel.text = "IMDB Rating: N/A"
        }
        self.movieSummaryLabel.text = summary ?? "N/A"
        self.infoLabel.text = info ?? "N/A"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        cardBackground.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
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
    
    private func configure() {
        movieImageView = MIImageView(frame: .zero)
        cardBackground.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 20),
            movieImageView.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        titleLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .headline), textColor: .label)
        titleLabel.numberOfLines = 0
        cardBackground.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
//            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        ratingLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: .label)
        ratingLabel.numberOfLines = 1
        cardBackground.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
//            ratingLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        infoLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: .label)
        infoLabel.numberOfLines = 1
        cardBackground.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
//            infoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        movieSummaryLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .body), textColor: .label)
        movieSummaryLabel.numberOfLines = 0
        movieSummaryLabel.sizeToFit()
        cardBackground.addSubview(movieSummaryLabel)
        NSLayoutConstraint.activate([
            movieSummaryLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            movieSummaryLabel.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 20),
            movieSummaryLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -20),
//            movieSummaryLabel.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: -20)
        ])
        movieImageView.sizeToFit()
    }
    
    func setMovieImage(from path: String) {
        movieImageView.downloadImage(fromPath: path)
    }
}
