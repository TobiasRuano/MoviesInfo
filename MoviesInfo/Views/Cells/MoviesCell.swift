//
//  MoviesCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    var cardBaseView: UIView!
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
        self.ratingLabel.text = String(movie.voteAverage)
        self.moreInfoLabel.text = movie.releaseDate
        let path = movie.posterPath
        self.movieImage.downloadImage(fromPath: path)
    }
    
    func setupComponents()  {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .secondarySystemBackground
        
        configureCardBaseView()
        configureMovieImage()
        configureText()
    }
    
    private func configureCardBaseView() {
        cardBaseView = UIView()
        addSubview(cardBaseView)

        cardBaseView.backgroundColor = .secondarySystemBackground
        cardBaseView.layer.shadowColor = UIColor.systemGray.cgColor
        cardBaseView.layer.shadowRadius = 5
        cardBaseView.layer.shadowOpacity = 0.3
        cardBaseView.layer.cornerRadius = 10

        cardBaseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardBaseView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cardBaseView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cardBaseView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cardBaseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func configureMovieImage() {
        movieImage = MIImageView(frame: .zero)
        cardBaseView.addSubview(movieImage)
        
        NSLayoutConstraint.activate([
            movieImage.centerYAnchor.constraint(equalTo: cardBaseView.centerYAnchor),
            movieImage.leadingAnchor.constraint(equalTo: cardBaseView.leadingAnchor, constant: 10),
            movieImage.widthAnchor.constraint(equalToConstant: 80),
            movieImage.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureText() {
        titleLabel = UILabel()
        moreInfoLabel = UILabel()
        ratingLabel = UILabel()
        
        cardBaseView.addSubview(titleLabel)
        cardBaseView.addSubview(moreInfoLabel)
        cardBaseView.addSubview(ratingLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            moreInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            moreInfoLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            moreInfoLabel.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            moreInfoLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingLabel.topAnchor.constraint(equalTo: moreInfoLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
