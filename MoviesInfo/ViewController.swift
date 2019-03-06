//
//  ViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    var dataDictionary = [[String : Any]]()
    let apiKey = "de5b247a6e6b7609efefe1a38f215388"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = dataDictionary.count
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MoviesCell
        cell.title.text = (dataDictionary[indexPath.row]["title"] as! String)
        cell.moreInfo.text = (dataDictionary[indexPath.row]["release_date"] as! String)
        let ratingNumber = dataDictionary[indexPath.row]["vote_average"]! as! Double
        cell.rating.text = String(format: "%.1f", ratingNumber)
        
        var movieGenres = [""]
        movieGenres = getGenres(ids: dataDictionary[indexPath.row]["genre_ids"] as! [Int])
        
        print(movieGenres)
        var genresText = ""
        for element in movieGenres {
            //genresText = genresText
            genresText.append(element)
            if movieGenres.last != element{
                genresText.append(" | ")
            }
        }
        cell.moreInfo.text = genresText
        
        //This should not be here
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(dataDictionary[indexPath.row]["poster_path"] as! String)")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.movieImage.image = UIImage(data: data!)
                cell.movieImage.layer.masksToBounds = true
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfo = dataDictionary[indexPath.row]
        performSegue(withIdentifier: "showInfo", sender: movieInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let destVC = segue.destination as! MovieInfoViewController
            destVC.info = (sender as? [String : Any])!
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        tableView.rowHeight = 138
        
        requestTopRatedMovies()
    }

    func requestTopRatedMovies() {
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&api_key=\(apiKey)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!)
                if let dictionary = jsonObject as? [String: Any],
                    let results = dictionary["results"] as?[[String: Any]] {
                    DispatchQueue.main.async {
                        results.forEach { print($0["body"] ?? "", terminator: "\n\n") }
                        //        self.tableData = results
                        //        self.Indextableview.reloadData()
//                        print(dictionary)
                        self.dataDictionary = results
                        print(self.dataDictionary.count)
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        })
        dataTask.resume()
    }
    
    func getGenres(ids: [Int]) -> [String] {
        var result = [String]()
        
        
        if let path = Bundle.main.path(forResource: "Genres", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! Dictionary<String, AnyObject>
                
                guard let jsonArray = jsonResult["genres"] as? [[String: Any]] else {
                    return result
                }
                
                var counter = 0
                for element in jsonArray {
                    if counter < ids.count && element["id"] as! Int == ids[counter] {
                        result.append(element["name"] as! String)
                        counter = counter + 1
                    }
                }
                //print(genre)
            } catch {
                // handle error
            }
        }
        return result
    }
    
}

