//
//  ProfileService.swift
//  Feed
//
//  Created by Leonardo Cunha on 14/10/25.
//

import Foundation
import FirebaseFirestore

protocol ProfileServicing {
    func getSubjects(userId: String) async throws -> [FolllowedSubject]
}

final class ProfileService: ProfileServicing {
    
    private let db = Firestore.firestore()
    
    
    func getSubjects(userId: String) async throws -> [FolllowedSubject] {
        var followedSubjects: [FolllowedSubject] = []

        let documents = try await db.collection("users").document(userId).collection("followedSubjects").order(by: "followedAt", descending: false).getDocuments()
            documents.documents.forEach { snapshot in
                let subject = try? snapshot.data(as: FolllowedSubject.self)
                if let subject = subject {
                    followedSubjects.append(subject)
                }
            }
        print(followedSubjects)

        return followedSubjects
    }

    func getSubjectInfo(subjectId: String) {
    }
}
