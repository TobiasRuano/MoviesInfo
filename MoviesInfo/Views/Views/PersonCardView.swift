//
//  PersonCardView.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 25/11/2021.
//  Copyright © 2021 Tobias Ruano. All rights reserved.
//

import UIKit

class PersonCardView: UIView {
    
    private var personImageView: MIImageView!
    private var nameLabel: UILabel!
    private var bornLabel: UILabel!
    private var biographyLabel: UILabel!
    
    private var cardBackground: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCardView()
        setViewStyle()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String, placeOfBirth: String?, birthday: String?, biography: String?) {
        self.init(frame: .zero)
        self.nameLabel.text = name
        
        var bornText = "Born: "
        if let born = birthday {
            bornText += born
            self.bornLabel.text = bornText
        }
        
        if let homeTown = placeOfBirth {
            bornText += " in \(homeTown)"
            self.bornLabel.text = bornText
        }
        
        // TODO: What happens if both variables are null ??
        
        self.biographyLabel.text = biography
    }
    
    func setViewStyle() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCardView() {
        self.cardBackground = UIView()
        self.cardBackground.backgroundColor = .secondarySystemBackground
        self.cardBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.cardBackground)
        NSLayoutConstraint.activate([
            self.cardBackground.topAnchor.constraint(equalTo: topAnchor),
            self.cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure() {
        personImageView = MIImageView(frame: .zero)
        cardBackground.addSubview(personImageView)
        
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 20),
            personImageView.centerXAnchor.constraint(equalTo: cardBackground.centerXAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: 150),
            personImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        nameLabel = MITitleLabel(textColor: .label)
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .center
        self.cardBackground.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.personImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.cardBackground.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.cardBackground.trailingAnchor, constant: -20)
        ])
        
        bornLabel = MILabel(font: .preferredFont(forTextStyle: .body), textColor: .label)
        self.cardBackground.addSubview(bornLabel)
        NSLayoutConstraint.activate([
            bornLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            bornLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            bornLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor)
        ])
        
        biographyLabel = MILabel(font: .preferredFont(forTextStyle: .body), textColor: .label)
        biographyLabel.numberOfLines = 0
        biographyLabel.sizeToFit()
        self.cardBackground.addSubview(biographyLabel)
        NSLayoutConstraint.activate([
            biographyLabel.topAnchor.constraint(equalTo: self.bornLabel.bottomAnchor, constant: 20),
            biographyLabel.leadingAnchor.constraint(equalTo: self.bornLabel.leadingAnchor),
            biographyLabel.trailingAnchor.constraint(equalTo: self.bornLabel.trailingAnchor)
        ])
        print("Biography heigth after set: \(biographyLabel.frame.height)")
    }
    
    func getViewHeight() -> CGFloat {
        let height = CGFloat(100) + self.personImageView.frame.height + self.nameLabel.frame.height + self.bornLabel.frame.height + self.biographyLabel.frame.height
        return height
    }
    
    func setPersonImage(from path: String) {
        personImageView.downloadImage(fromPath: path)
        personImageView.contentMode = .scaleAspectFill
    }
}
