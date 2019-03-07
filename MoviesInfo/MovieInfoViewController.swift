//
//  MovieInfoViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 06/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    @IBOutlet weak var MovieImageView: UIImageView!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var info = [String : Any]()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    override public func viewDidLoad()  {
        super.viewDidLoad()
        self.setupComponents()
        self.setupGestureRecognizers()
        self.setupUI()
        MovieImageView.image = UIImage(named: "test")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override public func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    private func setupComponents()  {
        // Setup baseShapeImageView
        self.MovieImageView.layer.shadowColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 0.42).cgColor /* #CACACA */
        self.MovieImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.MovieImageView.layer.shadowRadius = 18
        self.MovieImageView.layer.shadowOpacity = 1
        self.MovieImageView.layer.cornerRadius = 10
        
        CardView.layer.shadowColor = UIColor.gray.cgColor
        CardView.layer.shadowRadius = 5
        CardView.layer.shadowOpacity = 0.3
        
        CardView.layer.cornerRadius = 10
        CardView.layer.masksToBounds = false
    }
    
    private func setupGestureRecognizers()  {
        
    }
    
    private func setupUI()  {
        titleLabel.text = info["title"] as! String
        movieSummaryLabel.text = info["overview"] as! String
        ratingLabel.text = "IMDB Rating: \(info["vote_average"]!)"
        
        //Do stuff with the date before passing it to the label
        infoLabel.text = info["release_date"] as! String
        
        retriveImage()
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
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Status Bar
    
    override public var prefersStatusBarHidden: Bool  {
        return true
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle  {
        return .default
    }
}
