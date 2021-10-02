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
        viewControllers = [
            createFeedViewController(),
            createNewPost(),
            createProfileViewController()
        ]
        selectedIndex = 0
    }

    func createNewPost() -> UIViewController{
        let viewController = NewPostViewController()
        viewController.title = "Nova Postagem"
        viewController.tabBarItem.title = "Post"
        viewController.tabBarItem.image = UIImage(named: "ico-new-post")
        return viewController
    }
    func createFeedViewController() -> UIViewController{
        let viewController = FeedViewController()
        viewController.title = "Feed"
        viewController.tabBarItem.title = "Feed"
        viewController.tabBarItem.image = UIImage(named: "ico-feed")
        return viewController
    }
    func createProfileViewController() -> UIViewController{
        let viewController = ProfileViewController()
        viewController.title = "Perfil"
        viewController.tabBarItem.title = "Perfil"
        viewController.tabBarItem.image = UIImage(named: "ico-profile")
        return viewController
    }
}
