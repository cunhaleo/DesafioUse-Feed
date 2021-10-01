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
            createNewPost(),
            ProfileViewController()
        ]
        selectedIndex = 0
    }

    func createNewPost() -> UIViewController{
        let viewController = NewPostViewController()
        viewController.tabBarItem.title = "Postar"
        
        return viewController
    }



}
