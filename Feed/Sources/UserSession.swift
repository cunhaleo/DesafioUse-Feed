//
//  UserSession.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation

class UserSession {
    
    static let shared = UserSession()
    
    var name: String?
    var email: String?
    
    func logout() {
        name = nil
        email = nil
        FirebaseAuthManager.logout()
    }
}
