//
//  ImageCollectionViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 17/07/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    enum ViewControllerType {
        case similarMovies
        case personMovies
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    var titleView: UIView!
    var titleLabel: MILabel!
    
    var id: Int!
    var moviesArray: [Movie] = []
    
    var vcType: ViewControllerType!
    
    let network = NetworkManager.shared
    
    init(id: Int, type: ViewControllerType) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.vcType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        configureCollectionView()
        configureDataSource()
        requestMovies(page: 1)
    }
    
    func configureTitle() {
        titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .secondarySystemBackground
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        var title = ""
        switch vcType {
        case .similarMovies:
            title = "Similar Movies"
        case .personMovies:
            title = "Known for:"
        case .none:
            print("Error")
        }
        titleLabel = MILabel(font: UIFont.preferredFont(forTextStyle: .headline), textColor: .label)
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
    }
    
    func configureCollectionView()  {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneLineFlowLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.reuseID)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.reuseID, for: indexPath) as! SimilarMovieCell
            cell.setCell(with: movie)
            return cell
        })
    }
    
    func requestMovies(page: Int) {
        var urltype = ""
        var keypath = ""
        switch vcType {
        case .similarMovies:
            urltype = "movie/\(id!)/similar?"
            keypath = "results"
        case .personMovies:
            urltype = "person/\(id!)/movie_credits?"
            keypath = "cast"
        case .none:
            print("Error")
        }
        let requestURL = network.searchMovieURL(type: urltype, page: page)
        print(requestURL)
        network.fetchData(urlString: requestURL, castType: [Movie].self, keyPath: keypath) { [weak self] result in
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
        DispatchQueue.main.async {
            if self.moviesArray.isEmpty {
                let emptyUIView = MIEmptyStateView(message: "Unable to find titles related to this movie.")
                self.view.addSubview(emptyUIView)
                emptyUIView.frame = self.collectionView.frame
            } else {
                self.updateData(on: self.moviesArray)
            }
        }
    }
    
    func updateData(on movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension MoviesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = MovieInfoViewController()
        destVC.movie = moviesArray[indexPath.item]
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
