//
//  PostModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import Foundation

struct PostModel: Decodable {
    
    let message: String
    let userId: String
    let name: String
    let date: String
}

struct UserModel: Decodable {
    
    let name: String
    
}
