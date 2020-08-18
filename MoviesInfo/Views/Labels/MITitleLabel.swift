//
//  MITitleLabel.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 20/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MITitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textColor: UIColor) {
        self.init(frame: .zero)
        self.textColor = textColor
    }
    
    private func configure() {
        self.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
