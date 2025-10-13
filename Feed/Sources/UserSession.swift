//
//  UserSession.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation

final class UserSession {
    
    static let shared = UserSession()
    
    private(set) var name: String? {
        get{
            UserDefaults.standard.string(forKey: "keyName")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "keyName")
        }
    }
    private(set) var email: String? {
        get{
            UserDefaults.standard.string(forKey: "keyEmail")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "keyEmail")
        }
    }
        
        private(set) var userId: String? {
            get{
                UserDefaults.standard.string(forKey: "keyId")
            }
            set{
                UserDefaults.standard.setValue(newValue, forKey: "keyId")
            }
        }
    
    func finishSession() {
        name = nil
        email = nil
        userId = nil
    }
    
    func startSession(name: String, email: String, userId: String) {
        self.name = name
        self.email = email
        self.userId = userId
    }
}
