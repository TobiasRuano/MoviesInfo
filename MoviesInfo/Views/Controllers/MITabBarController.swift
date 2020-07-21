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
        viewControllers = [createHomeNC(), createWatchlistNC(), createAccountNC(), createSearchNC()]
    }
    
    private func createHomeNC() -> UINavigationController {
        let homeVC = TopRatedViewController()
        homeVC.title = "Top Rated"
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func createWatchlistNC() -> UINavigationController {
        let watchlistVC = WatchlistViewController()
        watchlistVC.title = "Watchlist"
        let accountImage = UIImage(systemName: "list.number")
        watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: accountImage, tag: 1)
        return UINavigationController(rootViewController: watchlistVC)
    }
    
    private func createAccountNC() -> UINavigationController {
        let accountVC = AccountViewController()
        accountVC.title = "Account"
        let accountImage = UIImage(systemName: "person.crop.circle.fill")
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: accountImage, tag: 2)
        return UINavigationController(rootViewController: accountVC)
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchvc = SearchViewController()
        searchvc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        return UINavigationController(rootViewController: searchvc)
    }
}
