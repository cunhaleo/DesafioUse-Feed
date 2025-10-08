//
//  FeedService.swift
//  Feed
//
//  Created by Leonardo Cunha on 07/10/25.
//

import FirebaseFirestore
import Foundation

protocol FeedServiceProtocol {
    func fetchPosts() async throws -> [PostModel]
    func fetchComments(from postId: String) async throws -> [Comment]
    func addComment(_ comment: Comment, to postId: String) async throws
}

final class FeedService: FeedServiceProtocol {

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
    
    func addComment(_ comment: Comment, to postId: String) async throws {
        let newCommentRef = db.collection("Posts").document(postId).collection("comments").document()
        let commentId = newCommentRef.documentID
        do {
            try await newCommentRef.setData([
                "commentId" : commentId,
                "message" : comment.message,
                "userId" : comment.userId,
                "userName" : comment.userName,
                "formattedDate" : comment.formattedDate,
                "date" : comment.date
            ])
        }
        catch {
            throw error
        }
    }
}
