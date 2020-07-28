//
//  CustomCollectionViewCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class SimilarMovieCell: UICollectionViewCell {
    
    private var movieImage: MIImageView!
    static let reuseID = "SimilarMovies"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        movieImage = MIImageView(frame: .zero)
        addSubview(movieImage)
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setCell(with movie: Movie) {
        if let path = movie.posterPath {
            self.movieImage.downloadImage(fromPath: path)
        }
    }
}
