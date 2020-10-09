//
//  WatchlistViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 21/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class WatchlistViewController: UITableViewController {
    
    private var watchlist: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWatchlist()
        checkTableViewEmptiness()
    }
    
    private func getWatchlist() {
        if let data = UserDefaults.standard.value(forKey: "watchlist") as? Data {
            let copy = try? PropertyListDecoder().decode([Movie].self, from: data)
            watchlist = copy!
            tableView.reloadData()
        }
    }
    
    func checkTableViewEmptiness() {
        if watchlist.isEmpty {
            let emptyUIView = MIEmptyStateView(message: "You haven't added any movie to your watchlist!")
            emptyUIView.tag = 1001
            self.view.addSubview(emptyUIView)
            emptyUIView.frame = self.view.frame
            emptyUIView.backgroundColor = .secondarySystemBackground
        } else {
            self.view.viewWithTag(1001)?.removeFromSuperview()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.reuseID, for: indexPath) as! MoviesCell
        cell.setCell(with: watchlist[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfo = watchlist[indexPath.row]
        let destVC = MovieInfoViewController()
        destVC.movie = movieInfo
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            watchlist.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.watchlist), forKey: "watchlist")
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkTableViewEmptiness()
        }
    }
    
}
