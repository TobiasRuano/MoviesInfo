//
//  MIImageView.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 11/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MIImageView: UIImageView {
    
    private let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    func style() {
        image = UIImage(named: "placeholder")
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.secondarySystemFill.cgColor
        layer.borderWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceHolder() {
        image = UIImage(named: "placeholder")
    }
    
    func downloadImage(fromPath path: String) {
        let url = "https://image.tmdb.org/t/p/w500\(path)"
        NetworkManager.shared.fetchImage(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.setImage(image: image)
            case .failure(let error):
                print("\(error): \(error.rawValue)")
            }
        }
    }
    
    private func setImage(image: UIImage) {
        DispatchQueue.main.async {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.image = image
            })
        }
    }
}
