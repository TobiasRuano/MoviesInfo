//
//  MovieInfoViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    @IBOutlet weak var MovieImageView: UIImageView!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var info = [String : Any]()
    var similarMoviesDictionary = [[String : Any]]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.setupComponents()
        self.setupGestureRecognizers()
        self.setupUI()
        MovieImageView.image = UIImage(named: "placeholder")
        MovieImageView.layer.masksToBounds = true

        
        print(info["id"] as! Int)
        
        //retriveSimilasMovies(movieID: info["id"] as! Int)
    }
    
    override public func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if similarMoviesDictionary.count == 0 {
            return 4
        }else {
            return similarMoviesDictionary.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.cellimage.image = UIImage(named: "placeholder")
        if similarMoviesDictionary.count != 0 {
            //cell.cellimage.image = retriveImage(posterID: similarMoviesDictionary[indexPath.row]["poster_path"] as! String)
        }
        
        DispatchQueue.main.async {
            cell.cellimage.image = self.MovieImageView.image
        }
        cell.cellimage.layer.masksToBounds = true
        
        return cell
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    private func setupComponents()  {
        MovieImageView.layer.shadowColor    = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 0.42).cgColor /* #CACACA */
        MovieImageView.layer.shadowOffset   = CGSize(width: 0, height: 8)
        MovieImageView.layer.shadowRadius   = 18
        MovieImageView.layer.shadowOpacity  = 1
        MovieImageView.layer.cornerRadius   = 10
        
        CardView.layer.shadowColor          = UIColor.gray.cgColor
        CardView.layer.shadowRadius         = 5
        CardView.layer.shadowOpacity        = 0.3
        CardView.layer.cornerRadius         = 10
        CardView.layer.masksToBounds        = false
    }
    
    private func setupGestureRecognizers()  {
        
    }
    
    private func setupUI()  {
        if let title = info["title"] as? String {
            titleLabel.text = title
        }
        if let overview = info["overview"] as? String {
            movieSummaryLabel.text = overview
        }
        ratingLabel.text = "IMDB Rating: \(info["vote_average"]!)"
        
        //Do stuff with the date before passing it to the label
        if let info = info["release_date"] as? String {
            infoLabel.text = info
        }
        
        retriveImage()
        
        //Update the collection View image
        collectionView.reloadData()
        collectionView.setNeedsDisplay()
    }
    
    func retriveImage() {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(info["poster_path"] as! String)")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.MovieImageView.image = UIImage(data: data!)
                self.MovieImageView.layer.masksToBounds = true
            }
        }
    }
    
    func retriveImage(posterID: String) -> UIImage {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterID)")
        var image = UIImage()
        
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
        }else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    self.imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                    image = imageToCache!
                }
            }
        }
        
        
        return image
    }
    
    
    func retriveSimilasMovies(movieID: Int) {
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(movieID)/similar?page=1&language=en-US&api_key=\(apiKey)")! as URL
        
        let request = NSMutableURLRequest(url: url,
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
                        self.similarMoviesDictionary = results
                        print(self.similarMoviesDictionary.count)
                    }
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        })
        dataTask.resume()
    }
}
