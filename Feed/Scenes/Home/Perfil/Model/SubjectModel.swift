//
//  SubjectModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 14/10/25.
//

import Foundation

struct SubjectModel: Codable {
    let subjectId: String
    let subjectName: String
    let description: String
    let followerCount: Int?
}

struct FolllowedSubject: Codable {
    let subjectId: String
    let subjectName: String
    let followedAt: Date
}
