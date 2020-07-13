//
//  MITabBarController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 11/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = HomeViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = AccountViewController()
        favoritesVC.title = "Account"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        return UINavigationController(rootViewController: favoritesVC)
    }
}
