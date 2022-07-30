//
//  HomeViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 21/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func presentAlertWithFeedback(icon: String, message: String, feedbackType: UINotificationFeedbackGenerator.FeedbackType)
}

class HomeViewController: UITableViewController {
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        viewModel.delegate = self
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        configureNavigationBar()
        viewModel.movieRequest(of: .nowPlaying)

		viewModel.movies.bind { [weak self] movies in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getWatchlist()
    }
    
    private func configureNavigationBar() {
        let image = UIImage(systemName: "ellipsis.circle")
        let action = #selector(changeEndPoint(sender:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "more"
    }
    
    @objc private func changeEndPoint(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Choose an option:", message: "", preferredStyle: .actionSheet)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as UIBarButtonItem
        }
        
        alert.addAction(UIAlertAction(title: "Now Playing", style: .default, handler: { (UIAlertAction) in
            self.viewModel.movieRequest(of: .nowPlaying)
            self.title = "Now Playing"
        }))
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default, handler: { (UIAlertAction) in
            self.viewModel.movieRequest(of: .upcoming)
            self.title = "Upcoming"
        }))
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default, handler: { (UIAlertAction) in
            self.viewModel.movieRequest(of: .topRated)
            self.title = "Top Rated"
        }))
        alert.addAction(UIAlertAction(title: "Popular", style: .default, handler: { (UIAlertAction) in
            self.viewModel.movieRequest(of: .popular)
            self.title = "Popular"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func configureTableView() {
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.movies.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.reuseID, for: indexPath) as! MoviesCell
		cell.setCell(with: viewModel.movies.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = MovieInfoViewController()
		destVC.movie = viewModel.movies.value[indexPath.row]
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let text = viewModel.watchlistContains(movieIndexPath: indexPath) ? "Remove from Watchlist" : "Add to Watchlist"
        let AddAction = UIContextualAction(style: .normal, title:  text, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.viewModel.addToWatchlist(movieIndexPath: indexPath.row)
            success(true)
        })
		AddAction.backgroundColor = viewModel.watchlistContains(movieIndexPath: indexPath) ? .systemRed : .systemBlue
        return UISwipeActionsConfiguration(actions: [AddAction])
    }
    
    private func presentStatusAlert(icon: String, message: String) {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(systemName: icon)
        statusAlert.title = "Done"
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 2
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
			guard !viewModel.isLoadingMovies.value else { return }
			viewModel.isLoadingMovies.value = true
            viewModel.requestMovies()
        }
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func presentAlertWithFeedback(icon: String, message: String, feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        presentStatusAlert(icon: icon, message: message)
        TapticEffectsService.performFeedbackNotification(type: feedbackType)
    }
}
