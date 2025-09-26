//
//  UserSession.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation

class UserSession {
    
    static let shared = UserSession()
    
    var name: String? {
        get{
            UserDefaults.standard.string(forKey: "keyName")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "keyName")
        }
    }
    var email: String? {
        get{
            UserDefaults.standard.string(forKey: "keyEmail")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "keyEmail")
        }
    }
    
    func finishSession() {
        name = nil
        email = nil
    }
    
    func startSession(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
