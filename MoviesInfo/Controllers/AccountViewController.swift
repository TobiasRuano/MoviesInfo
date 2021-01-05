//
//  AccountViewController.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 30/07/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import AuthenticationServices

class AccountViewController: UIViewController, AuthHandlerType {
    
    
    var session: NSObject?
    var webAuthSession: ASWebAuthenticationSession?
    
    let network = NetworkManager.shared
    var accountAvatar: MIImageView!
    var accountName: MILabel!
    var logInButton: MILoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setupAvatar()
        setupName()
        setupLogin()
    }
    
    func setupAvatar() {
        accountAvatar = MIImageView(frame: .zero)
        view.addSubview(accountAvatar)
        
        NSLayoutConstraint.activate([
            accountAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            accountAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountAvatar.widthAnchor.constraint(equalToConstant: 70),
            accountAvatar.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupName() {
        accountName = MILabel(font: .preferredFont(forTextStyle: .title1), textColor: .label)
        accountName.text = "N/A"
        accountName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountName)
        
        NSLayoutConstraint.activate([
            accountName.topAnchor.constraint(equalTo: accountAvatar.bottomAnchor, constant: 20),
            accountName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountName.widthAnchor.constraint(equalToConstant: 200),
            accountName.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupLogin() {
        logInButton = MILoginButton()
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        view.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: accountName.bottomAnchor, constant: 50),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.widthAnchor.constraint(equalToConstant: 100),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func logIn(_ sender: Any) {
        network.getToken { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                print(token)
                DispatchQueue.main.async {
                    self.configureAuthSession()
                }
            case .failure(let error):
                print("\(error): \(error.rawValue)")
            }
        }
        logInButton.setLogout()
    }
    
    private func configureAuthSession() {
        let authURL = URL(string: "https://www.themoviedb.org/authenticate/\(network.requestToken.requestToken!)")
        let callbackUrlScheme = "com.trotos.movies"
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            print(oauthToken ?? "No OAuth Token")
        })
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.start()
    }
}

extension AccountViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}
