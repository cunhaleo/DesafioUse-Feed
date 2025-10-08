//
//  FeedViewModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 07/10/25.
//

import FirebaseFirestore
import Foundation

protocol FeedViewModeling: AnyObject {
    var onDataUpdate: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var posts: [PostModel] { get }
    
    func fetchComments(for postId: String, completion: @escaping (([Comment]) -> Void))
    func loadFeed(completion: (() -> Void)?)
    func clearComments(for postId: String)
    func expandedComments(for postId: String) -> [Comment]?
    func isExpanded(postId: String) -> Bool
    func addComment(_ message: String, to postId: String)
    
}

final class FeedViewModel: FeedViewModeling {
    private let service: FeedServiceProtocol
    private(set) var posts: [PostModel] = []
    private(set) var expandedComments: [String: [Comment]] = [:]
    
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(service: FeedServiceProtocol = FeedService()) {
        self.service = service
    }
    
    func fetchComments(for postId: String, completion: @escaping (([Comment]) -> Void)) {
        var comments: [Comment] = []
        Task {
            do {
                comments = try await service.fetchComments(from: postId)
                expandedComments[postId] = comments
            }
            catch {
                onError?(error)
            }
            completion(comments)
        }
    }
    
    func loadFeed(completion: (() -> Void)?) {
        Task {
            do {
                self.posts = try await service.fetchPosts()
                onDataUpdate?()
            } catch {
                onError?(error)
            }
            completion?()
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
    
    func addComment(_ message: String, to postId: String) {
        guard let userName = UserSession.shared.name else { return }
        guard let userId = UserSession.shared.userId else { return }
        let comment = Comment(message: message,
                              date: Date(),
                              formattedDate: Date().getFormattedDate(format: .EEEEasHHmm),
                              userId: userId,
                              userName: userName)
        Task {
            do {
                try await service.addComment(comment, to: postId)
            } catch {
                onError?(error)
            }
        }
    }
}



