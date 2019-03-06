//
//  MoviesCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    @IBOutlet weak var cardBaseView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    override public func awakeFromNib()  {
        // Configure SN Generated code
        super.awakeFromNib()
        
        self.setupComponents()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupComponents()  {
        // Selection
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.white
        
        // Setup cardBaseView
        self.cardBaseView.layer.shadowColor = UIColor.gray.cgColor
        self.cardBaseView.layer.shadowRadius = 5
        self.cardBaseView.layer.shadowOpacity = 0.3
        
        self.cardBaseView.layer.cornerRadius = 10
        self.cardBaseView.layer.masksToBounds = false
        
        self.movieImage.layer.cornerRadius = 10
        
    }
    
    private func setupLocalization()  {
    }
}
