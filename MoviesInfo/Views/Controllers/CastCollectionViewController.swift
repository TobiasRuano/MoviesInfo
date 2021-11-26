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
    
    var titleView: UIView!
    var titleLabel: MILabel!
    
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
        configureTitle()
        configureCollectionView()
        configureDataSource()
        requestCast()
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
        
        let title = "Cast"
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
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseID)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 15),
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = castArray[indexPath.row]
        requestPersonDetails(personID: person.id)
    }
    
    func requestCast() {
        let urltype = "movie/\(movie.id)/credits?"
        let requestURL = network.searchMovieURL(type: urltype, page: 1)
        network.fetchData(urlString: requestURL, castType: [Cast].self, keyPath: "cast") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cast):
                self.updateUI(with: cast)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPersonDetails(personID: Int) {
        let requestUrl = network.getPersonDetailsURL(personID: personID)
        network.fetchData(urlString: requestUrl, castType: Person.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPerson):
                DispatchQueue.main.async {
                    self.presentPersonViewController(person: newPerson)
                }
            case .failure(let error):
                //TODO: Manage error
                print("\(error): \(error.rawValue)")
            }
        }
    }
    
    func presentPersonViewController(person: Person) {
        let personViewController = PeopleInfoViewController()
        personViewController.person = person
        self.navigationController?.pushViewController(personViewController, animated: true)
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
