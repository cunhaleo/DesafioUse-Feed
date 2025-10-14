//
//  ProfileService.swift
//  Feed
//
//  Created by Leonardo Cunha on 14/10/25.
//

import Foundation
import FirebaseFirestore

protocol ProfileServicing {
    func getSubjects(userId: String) async throws -> [String]
}

final class ProfileService: ProfileServicing {
    
    private let db = Firestore.firestore()
    
    
    func getSubjects(userId: String) async throws -> [String] {
        var subjectNames: [String] = []

        let documents = try await db.collection("users").document(userId).collection("followedSubjects").order(by: "followedAt", descending: false).getDocuments()
            documents.documents.forEach { snapshot in
                let subject = try? snapshot.data()
                if let subjectName = subject?["subjectName"] as? String {
                    subjectNames.append(subjectName)
                }
            }
        print(subjectNames)

        return subjectNames
    }

    func getSubjectInfo(subjectId: String) {
    }
}
