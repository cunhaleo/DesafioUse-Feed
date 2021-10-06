//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

   
    
    // MARK: - Actions
    
    @IBAction func buttonLogout(_ sender: Any) {
        UserSession.shared.logout()
        
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
        
    }
    //MARK: - Methods
    
    func setupUI() {
        title = "Perfil"

    }

}
    
