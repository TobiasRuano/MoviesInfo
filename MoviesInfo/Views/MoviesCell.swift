//
//  MoviesCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    // MARK: - Properties
    
    var cardBaseView: UIView!
    var movieImage: UIImageView!
    var title: UILabel!
    var moreInfo: UILabel!
    var rating: UILabel!
    
    static let reuseID = "Cell"
    
    // MARK: - Setup

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(with movie: Movie) {
        self.title.text = movie.title
        self.rating.text = String(movie.voteAverage)
        self.moreInfo.text = movie.releaseDate
        getImage(from: movie.posterPath)
        self.movieImage.layer.masksToBounds = true
    }
    
    private func getImage(from posterPath: String) {
        let url = "https://image.tmdb.org/t/p/w500\(posterPath)"
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.movieImage.image = image
            }
        }
    }
    
    func setupComponents()  {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.white
        
        configureCardBaseView()
        configureMovieImage()
        configureText()
    }
    
    private func configureCardBaseView() {
        cardBaseView = UIView()
        self.addSubview(cardBaseView)
        
        self.cardBaseView.layer.shadowColor = UIColor.gray.cgColor
        self.cardBaseView.layer.shadowRadius = 5
        self.cardBaseView.layer.shadowOpacity = 0.3
        self.cardBaseView.layer.cornerRadius = 10
        self.cardBaseView.layer.masksToBounds = false
        
        cardBaseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardBaseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cardBaseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            cardBaseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cardBaseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
        ])
    }
    
    private func configureMovieImage() {
        movieImage = UIImageView()
        cardBaseView.addSubview(movieImage)
        
        self.movieImage.layer.cornerRadius = 10
        
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: cardBaseView.topAnchor, constant: 10),
            movieImage.leadingAnchor.constraint(equalTo: cardBaseView.leadingAnchor, constant: 10),
            movieImage.widthAnchor.constraint(equalToConstant: 75),
            movieImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureText() {
        title = UILabel()
        moreInfo = UILabel()
        rating = UILabel()
        
        cardBaseView.addSubview(title)
        cardBaseView.addSubview(moreInfo)
        cardBaseView.addSubview(rating)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        rating.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: movieImage.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            title.heightAnchor.constraint(equalToConstant: 25),
            
            moreInfo.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            moreInfo.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            moreInfo.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            moreInfo.heightAnchor.constraint(equalToConstant: 25),
            
            rating.topAnchor.constraint(equalTo: moreInfo.bottomAnchor, constant: 10),
            rating.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            rating.trailingAnchor.constraint(equalTo: cardBaseView.trailingAnchor, constant: -20),
            rating.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
