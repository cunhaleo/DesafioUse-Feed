//
//  FirebaseAuthManager.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    
    // MARK: Properties
    private static let db = Firestore.firestore()
    private static let userSession = UserSession.shared
    
    
    // MARK: Methods
    static func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let userId = result.user.uid
            let user = try await getUserDocument(userId: userId)
            userSession.startSession(name: user.name, email: user.email)
        } catch {
            throw error
        }
    }
    
    
    static private func getUserDocument(userId: String) async throws -> UserModel {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            let user = try document.data(as: UserModel.self)
            return user
        } catch {
            throw error
        }
    }
    
    static func createAccount(name: String, email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = result.user.uid
            try await db.collection("users").document(userId).setData([
                "name": name,
                "email": email
            ])
            userSession.startSession(name: name, email: email)
        } catch {
            throw error
        }
    }
    
    static func logout() {
        try? Auth.auth().signOut()
        userSession.finishSession()
    }
}
