//
//  MoviesCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    private var movieImage: MIImageView!
    private var titleLabel: MILabel!
    private var moreInfoLabel: UILabel!
    private var ratingLabel: MILabel!
    private var imdbLogo: UIImageView!
    
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
        if let date = movie.releaseDate?.convertToDisplayFormat() {
            self.moreInfoLabel.text = "Released: \(date)"
        } else {
            self.moreInfoLabel.text = "Released on: N/A"
        }
        if let path = movie.posterPath {
            self.movieImage.downloadImage(fromPath: path)
        }
    }
    
    private func setupComponents()  {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .secondarySystemBackground
        configureMovieImage()
        configureText()
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.ratingLabel.text = "N/A"
        self.moreInfoLabel.text = ""
//        self.movieImage.setPlaceHolder()
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
        titleLabel = MILabel(font: .preferredFont(forTextStyle: .headline), textColor: .label)
        moreInfoLabel = UILabel()
        ratingLabel = MILabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .label)
        imdbLogo = UIImageView(image: UIImage(named: "imdb.png"))
        
        addSubview(titleLabel)
        addSubview(moreInfoLabel)
        addSubview(ratingLabel)
        addSubview(imdbLogo)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        imdbLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            moreInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            moreInfoLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            moreInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            moreInfoLabel.heightAnchor.constraint(equalToConstant: 25),
            
            imdbLogo.topAnchor.constraint(equalTo: moreInfoLabel.bottomAnchor, constant: 10),
            imdbLogo.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            imdbLogo.widthAnchor.constraint(equalToConstant: 36),
            imdbLogo.heightAnchor.constraint(equalToConstant: 18),
            
            ratingLabel.centerYAnchor.constraint(equalTo: imdbLogo.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: imdbLogo.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
