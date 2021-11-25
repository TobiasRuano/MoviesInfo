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
    
    private var personCardView: PersonCardView!
    
    private var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configurePersonCardView()
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
    
    private func configurePersonCardView() {
        self.personCardView = PersonCardView(name: person.name, placeOfBirth: person.placeOfBirth, birthday: person.birthday, biography: person.biography)
        
        view.addSubview(self.personCardView)
        
        constraint = self.personCardView.heightAnchor.constraint(equalToConstant: self.personCardView.getViewHeight())
        constraint.isActive = true
        
        NSLayoutConstraint.activate([
            self.personCardView.topAnchor.constraint(equalTo: view.topAnchor),
            self.personCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.personCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updatePersonCardViewHeightConstraint() {
        let height = self.personCardView.getViewHeight()
        constraint.constant = height
        self.view.layoutIfNeeded()
    }
}
