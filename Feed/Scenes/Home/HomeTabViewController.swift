//
//  HomeTabViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class HomeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        viewControllers = [
            createFeedViewController(),
            createNewPost(),
            createProfileViewController()
        ]
        selectedIndex = 0
    }

    func createNewPost() -> UIViewController{
        let viewController = NewPostViewController()
        viewController.tabBarItem.title = "Post"
        viewController.tabBarItem.image = UIImage(named: "ico-new-post")
        return viewController
    }
    
    func createFeedViewController() -> UIViewController{
        let viewController = FeedViewController()
        viewController.tabBarItem.title = "Feed"
        viewController.tabBarItem.image = UIImage(named: "ico-feed")
        return viewController
    }
    
    func createProfileViewController() -> UIViewController{
        let viewController = ProfileViewController()
        viewController.tabBarItem.title = "Perfil"
        viewController.tabBarItem.image = UIImage(named: "ico-profile")
        return viewController
    }
    
    func setupTabBarUI() {
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.tintColor = .systemYellow
        
    }
}
