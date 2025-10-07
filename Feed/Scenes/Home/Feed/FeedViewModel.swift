import FirebaseFirestore

import Foundation

final class FeedViewModel {
    private let db = Firestore.firestore()
    private(set) var posts: [PostModel] = []
    private(set) var expandedPosts: [Int: [Comment]] = [:]

    var onDataUpdate: (() -> Void)?

    func fetchPosts() async -> [PostModel] {
        let posts = try await db.collection("posts").getDocuments()
        return posts.documents.map { $0.data() }
    }

    func fetchComments(for postId: String) async -> [Comment] {
        let comments = try await db.collection("posts").document(postId).collection("comments").getDocuments()
        if expandedPosts[postId] == nil {
            expandedPosts[postId] = comments
        return comments.documents.map { $0.data() }
    }

    func comment(for postId: String, message: String) async -> [Comment] {

}