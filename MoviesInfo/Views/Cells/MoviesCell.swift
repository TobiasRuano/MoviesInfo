//
//  MoviesCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    var movieImage: MIImageView!
    var titleLabel: UILabel!
    var moreInfoLabel: UILabel!
    var ratingLabel: UILabel!
    
    static let reuseID = "Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .secondarySystemBackground
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with movie: Movie) {
        self.titleLabel.text = movie.title
        if let rating = movie.voteAverage {
            self.ratingLabel.text = String(rating)
        } else {
            self.ratingLabel.text = "N/A"
        }
        self.moreInfoLabel.text = movie.releaseDate
        if let path = movie.posterPath {
            self.movieImage.downloadImage(fromPath: path)
        } else {
            self.movieImage.downloadImage(fromPath: "path")
        }
    }
    
    func setupComponents()  {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .secondarySystemBackground
        configureMovieImage()
        configureText()
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.ratingLabel.text = "N/A"
        self.moreInfoLabel.text = ""
        self.movieImage.downloadImage(fromPath: "path")
    }
    
    private func configureMovieImage() {
        movieImage = MIImageView(frame: .zero)
        addSubview(movieImage)
        
        NSLayoutConstraint.activate([
            movieImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieImage.widthAnchor.constraint(equalToConstant: 80),
            movieImage.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureText() {
        titleLabel = UILabel()
        moreInfoLabel = UILabel()
        ratingLabel = UILabel()
        
        addSubview(titleLabel)
        addSubview(moreInfoLabel)
        addSubview(ratingLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            moreInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            moreInfoLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            moreInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            moreInfoLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingLabel.topAnchor.constraint(equalTo: moreInfoLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
