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
    private var cardView: UIView!
    private var titleLabel: MILabel!
    private var ratingLabel: MILabel!
    private var movieSummaryLabel: MILabel!
    private var infoLabel: MILabel!
    
    #warning("Add properties to init")
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setViewStyle()
        configure()
    }
    
    convenience init(title: String, rating: Double, summary: String, info: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        ratingLabel.text = "IMDB Rating: \(rating)"
        self.movieSummaryLabel.text = summary
        self.infoLabel.text = info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func configure() {
        movieImageView = MIImageView(frame: .zero)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.layer.shadowColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 0.42).cgColor
        movieImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        movieImageView.layer.shadowRadius = 18
        movieImageView.layer.shadowOpacity = 1
        movieImageView.layer.cornerRadius = 10
        addSubview(movieImageView)
        
        titleLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .title1), textColor: .label)
        NSLayoutConstraint.activate([
            
        ])
        addSubview(titleLabel)
        
        ratingLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .title1), textColor: .label)
        NSLayoutConstraint.activate([
            
        ])
        addSubview(ratingLabel)
        
        movieSummaryLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .title1), textColor: .label)
        NSLayoutConstraint.activate([
            
        ])
        addSubview(movieSummaryLabel)
        
        infoLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .title1), textColor: .label)
        NSLayoutConstraint.activate([
            
        ])
        addSubview(infoLabel)
    }
    
    func setMovieImage(from path: String) {
        movieImageView.downloadImage(fromPath: path)
    }
}
