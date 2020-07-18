//
//  UIHelper.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 14/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

enum UIHelper {
    static func createOneLineFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let padding: CGFloat = 20
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: 100, height: 150)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let witdh = view.bounds.width
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        let availableWidth = witdh - (padding * 2) - (minimunItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        
        return flowLayout
    }
}
