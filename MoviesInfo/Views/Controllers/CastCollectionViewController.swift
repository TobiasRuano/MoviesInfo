//
//  CastCollectionViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 20/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class CastCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cast>!
    
    private var movie: Movie!
    private var cast: Cast!
    private var castArray: [Cast] = []
    private let person: [(name: String, role: String)] = []
    
    private let network = NetworkManager.shared
    
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        requestCast()
    }
    
    func configureCollectionView()  {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneLineFlowLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseID)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Cast>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cast) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseID, for: indexPath) as! CastCell
            cell.set(cast: cast)
            return cell
        })
    }
    
    func requestCast() {
        let urltype = "movie/\(movie.id)/credits?"
        let requestURL = network.getMovieURL(type: urltype, page: 1)
        network.fetchCast(type: requestURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cast):
                self.updateUI(with: cast)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUI(with cast: [Cast]) {
        castArray.append(contentsOf: cast)
        let sortedArray = castArray.sorted(by: { $0.order! < $1.order! })
        DispatchQueue.main.async {
            if self.castArray.isEmpty {
                let emptyUIView = MIEmptyStateView(message: "It seems this movie does not have a cast... Head to themoviedb.org and update their database!.")
                self.view.addSubview(emptyUIView)
                emptyUIView.frame = self.collectionView.frame
            } else {
                self.updateData(on: sortedArray)
            }
        }
    }
    
    func updateData(on cast: [Cast]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cast>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cast)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
