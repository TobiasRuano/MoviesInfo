//
//  CustomCollectionViewCell.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellimage: UIImageView!
    
    override public func awakeFromNib()  {
        // Configure SN Generated code
        super.awakeFromNib()
        
        self.setupUI()
    }
    func setupUI() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
        cellimage.layer.cornerRadius = 10
    }
}
