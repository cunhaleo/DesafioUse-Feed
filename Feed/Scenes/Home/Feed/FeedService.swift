//
//  FeedService.swift
//  Feed
//
//  Created by Leonardo Cunha on 07/10/25.
//

import FirebaseFirestore
import Foundation

final class FeedService {
    private let db = Firestore.firestore()
    
    func fetchPosts() async throws -> [PostModel] {
        var ordenedPosts: [PostModel] = []

            ordenedPosts.removeAll()
            let postCollection = try await db.collection("Posts").getDocuments()
            
            for document in postCollection.documents {
                let post = try document.data(as: PostModel.self)
                ordenedPosts.append(post)
            }
            ordenedPosts.sort(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
        
        return ordenedPosts
    }
    
    func fetchComments(from postId: String) async throws -> [Comment] {
        var comments: [Comment] = []

            let documents = try await db.collection("Posts").document(postId).collection("comments").order(by: "date", descending: false).getDocuments()
            documents.documents.forEach { snapshot in
                let comment = try? snapshot.data(as: Comment.self)
                if let comment = comment {
                    comments.append(comment)
                }
            }

        return comments
    }
}
