//
//  FeedViewModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 07/10/25.
//

import FirebaseFirestore
import Foundation

final class FeedViewModel {
    private let service: FeedService
    private(set) var posts: [PostModel] = []
    private(set) var expandedComments: [String: [Comment]] = [:]
    
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    var shouldShowLoading: ((Bool) -> Void)?
    
    
    init(service: FeedService = FeedService()) {
        self.service = service
    }
    
    func fetchComments(for postId: String, completion: @escaping (([Comment]) -> Void)) {
        var comments: [Comment] = []
        Task {
            do {
                shouldShowLoading?(true)
                comments = try await service.fetchComments(from: postId)
                expandedComments[postId] = comments
                completion(comments)
            }
            catch {
                onError?(error)
            }
            shouldShowLoading?(false)
        }
    }
    
    func loadFeed() {
        Task {
            shouldShowLoading?(true)
            do {
                self.posts = try await service.fetchPosts()
                onDataUpdate?()
            } catch {
                onError?(error)
            }
            shouldShowLoading?(false)
        }
    }
    
    func clearComments(for postId: String) {
        if expandedComments[postId] != nil {
            expandedComments[postId] = nil
        }
    }
    
    func expandedComments(for postId: String) -> [Comment]? {
        expandedComments[postId]
    }
    
    func isExpanded(postId: String) -> Bool {
        expandedComments[postId] != nil
    }
}



