//
//  MIEmptyStateView.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MIEmptyStateView: UIView {
    
    private let messageLabel = MILabel(font: .preferredFont(forTextStyle: .headline), textColor: .label)
    private let logoImageView = UIImageView(image: UIImage(systemName: "film"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
        backgroundColor = .systemBackground
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        configureLogoImageView()
        configureMessageLabel()
    }
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -10),
            messageLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
