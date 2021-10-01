//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @objc
    private func handlerButtonLogout() {
        UserSession.shared.logout()
        
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
    
    // MARK: - Methods
    private func setupUI() {
        let buttonLogout = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handlerButtonLogout))
        
        navigationItem.leftBarButtonItem = buttonLogout
        
    }

}
    
