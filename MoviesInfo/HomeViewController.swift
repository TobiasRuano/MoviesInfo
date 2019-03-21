//
//  ViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 05/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    //@IBOutlet weak var tableView: UITableView!
    var dataDictionary = [[String : Any]]()
    //let apiKey = "de5b247a6e6b7609efefe1a38f215388"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 148
        
        requestTopRatedMovies()
    }
    
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
        var arrayToPass = dataDictionary[indexPath.row]["genre_ids"] as! [Int]
        
        var counter = 0
        for item in dataDictionary[indexPath.row]["genre_ids"] as! [Int] {
            arrayToPass[counter] = item
            counter = counter + 1
        }
        
        movieGenres = getGenres(ids: arrayToPass)
        
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
        
        //TODO: This should not be here
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(dataDictionary[indexPath.row]["poster_path"] as! String)")
        cell.movieImage.image = UIImage(named: "placeholder")

        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            cell.movieImage.image = imageFromCache
        }else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    self.imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                    cell.movieImage.image = imageToCache
                }
            }
        }

        cell.movieImage.layer.masksToBounds = true
        
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
                        //        print(dictionary)
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
                
                //var counter = 0
//                for element in jsonArray {
//                    if counter < ids.count && element["id"] as! Int == ids[counter] {
//                        result.append(element["name"] as! String)
//                        counter = counter + 1
//                    }
//                }
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
    
}

