//
//  AssetsManager.swift
//  Feed
//
//  Created by Leonardo Cunha on 25/09/25.
//

import UIKit

enum AssetsManager {
    static let imageFeed = UIImage(named: "ico-feed") ?? UIImage()
        
    static let imageProfile = UIImage(named: "ico-profile") ?? UIImage()
    
    static let imageNewPost = UIImage(named: "ico-new-post") ?? UIImage()
    
    static let colorPrimary = UIColor(named: "colorPrimary") ?? .systemBlue
    
    static let colorSecondary = UIColor(named: "colorSecondary") ?? .systemGray
    
    static let colorBackground = UIColor(named: "colorBackground") ?? .white
}
