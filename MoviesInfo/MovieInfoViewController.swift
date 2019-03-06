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
    
    @IBOutlet weak var baseShapeImageView: UIImageView!
    @IBOutlet weak var rectangle3View: UIView!
    private var allGradientLayers: [CAGradientLayer] = []
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
        baseShapeImageView.image = UIImage(named: "test")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override public func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    private func setupComponents()  {
        // Setup baseShapeImageView
        self.baseShapeImageView.layer.shadowColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 0.42).cgColor /* #CACACA */
        self.baseShapeImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.baseShapeImageView.layer.shadowRadius = 18
        self.baseShapeImageView.layer.shadowOpacity = 1
        self.baseShapeImageView.layer.cornerRadius = 10
        
        rectangle3View.layer.shadowColor = UIColor.gray.cgColor
        rectangle3View.layer.shadowRadius = 5
        rectangle3View.layer.shadowOpacity = 0.3
        
        rectangle3View.layer.cornerRadius = 10
        rectangle3View.layer.masksToBounds = false
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
                self.baseShapeImageView.image = UIImage(data: data!)
                self.baseShapeImageView.layer.masksToBounds = true
            }
        }
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Layout
    
    override public func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        for layer in self.allGradientLayers {
            layer.frame = layer.superlayer?.frame ?? CGRect.zero
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
