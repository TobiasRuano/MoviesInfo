//
//  PeopleInfoViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 24/11/2021.
//  Copyright © 2021 Tobias Ruano. All rights reserved.
//

import UIKit

class PeopleInfoViewController: UIViewController {
    
    private let network = NetworkManager.shared
    
    var person: Person!
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var personCardView: PersonCardView!
    private var actedOnMoviesView: UIView!
    
    private var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureScrollView()
        configureContentView()
        configurePersonCardView()
        configureActedOnMoviesView()
    }
    
    override func viewDidLayoutSubviews() {
        updatePersonCardViewHeightConstraint()
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    private func updateUI(with person: Person) {
        DispatchQueue.main.async {
            self.title = person.name
        }
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configurePersonCardView() {
        self.personCardView = PersonCardView(name: person.name, placeOfBirth: person.placeOfBirth, birthday: person.birthday, biography: person.biography)
        if let path = person.profilePath {
            self.personCardView.setPersonImage(from: path)
        }
        
        contentView.addSubview(self.personCardView)
        
        constraint = self.personCardView.heightAnchor.constraint(equalToConstant: self.personCardView.getViewHeight())
        constraint.isActive = true
        
        NSLayoutConstraint.activate([
            self.personCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.personCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.personCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func updatePersonCardViewHeightConstraint() {
        let height = self.personCardView.getViewHeight()
        constraint.constant = height
        self.view.layoutIfNeeded()
    }
    
    private func configureActedOnMoviesView()  {
        actedOnMoviesView = UIView()
        actedOnMoviesView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actedOnMoviesView)
        
        self.add(childVC: MoviesCollectionViewController(id: person.id, type: .personMovies), to: self.actedOnMoviesView)
        
        NSLayoutConstraint.activate([
            actedOnMoviesView.topAnchor.constraint(equalTo: personCardView.bottomAnchor, constant: 20),
            actedOnMoviesView.heightAnchor.constraint(equalToConstant: 190),
            actedOnMoviesView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actedOnMoviesView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
