//
//  MIEmptyStateView.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MIEmptyStateView: UIView {
    
//    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let messageLabel = MILabel(font: .preferredFont(forTextStyle: .headline), textColor: .label)
    let logoImageView = UIImageView(image: UIImage(systemName: "film"))
    
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
    
    func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
//        let labelCenterYConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? -80 : -150
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func configureLogoImageView() {
//        logoImageView.image = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
//        let logoBottomConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? 80 : 40
        
        NSLayoutConstraint.activate([
//            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant),
//            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
//            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
//            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3)
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
