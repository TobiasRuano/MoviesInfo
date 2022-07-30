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
        viewControllers = [createHomeNC(), createWatchlistNC(), createSearchNC()]
    }
    
    private func createHomeNC() -> UINavigationController {
        let homeVC = HomeViewController()
        homeVC.title = "Now Playing"
        let tvImage = UIImage(systemName: "tv")
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: tvImage, tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func createWatchlistNC() -> UINavigationController {
        let watchlistVC = WatchlistViewController()
        watchlistVC.title = "Watchlist"
        let listImage = UIImage(systemName: "list.number")
        watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: listImage, tag: 1)
        return UINavigationController(rootViewController: watchlistVC)
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchvc = SearchViewController()
        searchvc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        return UINavigationController(rootViewController: searchvc)
    }
}
