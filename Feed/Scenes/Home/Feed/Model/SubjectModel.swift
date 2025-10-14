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
    let followerCount: Int?
}
