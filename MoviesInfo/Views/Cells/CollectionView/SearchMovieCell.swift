//
//  SearchMovieCollectionViewCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class SearchMovieCell: UICollectionViewCell {
    
    static let reuseID = "SearchCell"
    private let movieImageView = MIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(movieImageView)
        configureAvatarImageView()
    }
    
    func set(movie: Movie) {
        if let path = movie.posterPath {
            self.movieImageView.downloadImage(fromPath: path)
        }
    }
    
    override func prepareForReuse() {
        movieImageView.image = UIImage(named: "placeholder")
    }
    
    private func configureAvatarImageView() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
