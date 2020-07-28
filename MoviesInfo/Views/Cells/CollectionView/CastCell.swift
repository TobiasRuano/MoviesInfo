//
//  CastCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 20/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    static let reuseID = "CastCell"
    private let castImageView = MIImageView(frame: .zero)
    private let nameLabel = UILabel()
    private let roleLabel = UILabel()
    private var person: (name: String?, role: String?) = ("", "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureAvatarImageView()
        configurePersonsLabel()
    }
    
    func set(cast: Cast) {
        if let path = cast.profilePath {
            self.castImageView.downloadImage(fromPath: path)
        }
        self.person = (name: cast.name, role: cast.character)
        nameLabel.text = person.name ?? "N/A"
        roleLabel.text = person.role ?? "N/A"
    }
    
    override func prepareForReuse() {
        castImageView.image = UIImage(named: "placeholder")
    }
    
    private func configureAvatarImageView() {
        addSubview(castImageView)
        castImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            castImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            castImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            castImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            castImageView.heightAnchor.constraint(equalToConstant: 97)
        ])
        castImageView.setNeedsLayout()
    }
    
    func configurePersonsLabel() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .label
        contentView.addSubview(nameLabel)
        
        roleLabel.textAlignment = .center
        roleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.textColor = .secondaryLabel
        contentView.addSubview(roleLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: castImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            roleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            roleLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}
