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
        ProfileViewController()
        
        
        ]
        selectedIndex = 0
    }




}
