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
    
    func comments(for postId: String) async -> [Comment] {
        if expandedComments[postId] != nil {
            return expandedComments[postId] ?? []
        }
        else {
            let comments = await service.fetchComments(from: postId)
            expandedComments[postId] = comments
            return comments
            
        }
    }
    
    func loadFeed() {
        Task {
            shouldShowLoading?(true)
            self.posts = await service.fetchPosts()
            onDataUpdate?()
            shouldShowLoading?(false)
        }
    }
    
    func toggleComments(for postId: String) {
        if expandedComments[postId] != nil {
            expandedComments[postId] = nil
        } 
    }
    
    
    func comments(for postId: String) -> [Comment]? {
        expandedComments[postId]
    }
    
    func isExpanded(postId: String) -> Bool {
        expandedComments[postId] != nil
    }
}



