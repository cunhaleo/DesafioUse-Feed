//
//  HomeTabViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

final class HomeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createFeedViewController(),
            createNewPost(),
            createProfileViewController()
        ]
        selectedIndex = 0
        setupTabBarUI()
    }

    func createNewPost() -> UIViewController{
        let viewController = NewPostViewController()
        viewController.tabBarItem.title = "Post"
        viewController.tabBarItem.image = AssetsManager.imageNewPost
        return viewController
    }
    
    func createFeedViewController() -> UIViewController{
        let viewController = FeedViewController()
        viewController.tabBarItem.title = "Feed"
        viewController.tabBarItem.image = AssetsManager.imageFeed
        return viewController
    }
    
    func createProfileViewController() -> UIViewController{
        let viewController = ProfileViewController()
        viewController.tabBarItem.title = "Perfil"
        viewController.tabBarItem.image = AssetsManager.imageProfile
        return viewController
    }
    
    func setupTabBarUI() {
        self.tabBar.unselectedItemTintColor = AssetsManager.colorSecondary
        self.tabBar.tintColor = AssetsManager.colorPrimary
        
    }
}
