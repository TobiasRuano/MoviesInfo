//
//  ViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    var moviesArray: [Movie] = []
    
    var tableView: UITableView!
    
    let network = NetworkManager.shared
    var dataDictionary = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableview()
        navigationItem.title = "Top Rated"
        requestTopRatedMovies()
    }
    
    func configureTableview() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 148
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseID)
    }
    
    //TODO: - function to update the UI with the data from network manager
//    func updateUIWithData() {
//        network.requestTopRatedMovies()
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    
    func getGenres(ids: [Int]) -> [String] {
        var result = [String]()
        
        if let path = Bundle.main.path(forResource: "Genres", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! Dictionary<String, AnyObject>
                
                guard let jsonArray = jsonResult["genres"] as? [[String: Any]] else {
                    return result
                }
                for genre in ids {
                    var counter = 0
                    while counter < jsonArray.count  && jsonArray[counter]["id"] as! Int != genre {
                        counter = counter + 1
                    }
                    result.append(jsonArray[counter]["name"] as! String)
                    counter = 0
                }
            } catch {
                //TODO: handle error
                result.append("nil")
            }
        }
        return result
    }
    
    func requestTopRatedMovies() {
        #warning("Change the page number")
        let urltype = "movie/top_rated?"
        network.getMovies(type: urltype, page: 1) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUI(with movies: [Movie]) {
        moviesArray.append(contentsOf: movies)
        self.tableView.reloadData()
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "showInfo" {
        //            let destVC = segue.destination as! MovieInfoViewController
        //            destVC.info = (sender as? [String : Any])!
        //        }
        if segue.identifier == "showInfo" {
            let destVC = segue.destination as! MovieInfoViewController
            destVC.info2 = (sender as? Movie)!
        }
    }
}

//MARK: - TableView delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = moviesArray.count
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.reuseID, for: indexPath) as! MoviesCell
        cell.setCell(with: moviesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let movieInfo = dataDictionary[indexPath.row]
        let movieInfo = moviesArray[indexPath.row]
        print(movieInfo.title)
        
        performSegue(withIdentifier: "showInfo", sender: movieInfo)
    }
}

