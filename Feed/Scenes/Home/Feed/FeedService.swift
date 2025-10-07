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
    
    var showLoading: ((Bool) -> Void)?
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchPosts() async -> [PostModel] {
        var ordenedPosts: [PostModel] = []
        do {
            ordenedPosts.removeAll()
            showLoading?(true)
            let postCollection = try await db.collection("Posts").getDocuments()
            
            for document in postCollection.documents {
                let post = try document.data(as: PostModel.self)
                ordenedPosts.append(post)
            }
            ordenedPosts.sort(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
            self.onDataUpdate?()
        }
        catch {
            self.onError?(error)
            print("===> ERROR: \(error.localizedDescription)") // TODO: ADD ERROR HANDLER
        }
        showLoading?(false)
        return ordenedPosts
    }
    
    func fetchComments(from postId: String) async -> [Comment] {
        var comments: [Comment] = []
        do {
            showLoading?(true)
            let documents = try await db.collection("Posts").document(postId).collection("comments").order(by: "date", descending: false).getDocuments()
            documents.documents.forEach { snapshot in
                let comment = try? snapshot.data(as: Comment.self)
                if let comment = comment {
                    comments.append(comment)
                }
            }
            onDataUpdate?()
        }
        catch {
            onError?(error)
        }
        showLoading?(false)
        return comments
    }
}
