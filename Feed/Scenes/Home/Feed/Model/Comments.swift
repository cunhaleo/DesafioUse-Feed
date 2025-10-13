//
//  Comments.swift
//  Feed
//
//  Created by Leonardo Cunha on 02/10/25.
//

import Foundation

struct Comment: Codable {
    var commentId: String?
    var message: String
    var date: Date
    var formattedDate: String
    var userId: String
    var userName: String
}
