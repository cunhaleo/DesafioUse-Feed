//
//  PostModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation

struct PostModel: Codable {
    
    var postId: String?
    let message: String
    let userId: String
    let name: String
    let date: Date
    let formattedDate: String
}
