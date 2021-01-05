//
//  AuthHandlerType.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 01/08/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation
import AuthenticationServices

typealias AuthHandlerCompletion = (URL?, Error?) -> Void

protocol AuthHandlerType: class {
    var session: NSObject? { get set }
    func auth(url: URL, callbackScheme: String, completion: @escaping AuthHandlerCompletion)
}

extension AuthHandlerType {
    func auth(url: URL, callbackScheme: String, completion: @escaping AuthHandlerCompletion) {
        if #available(iOS 12, *) {
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) {
                url, error in
                completion(url, error)
            }
            session.start()
            self.session = session
        } else {
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) {
                url, error in
                completion(url, error)
            }
            session.start()
            self.session = session
        }
    }
}
