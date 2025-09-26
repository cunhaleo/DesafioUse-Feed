//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewInitials: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Perfil"
    }
    
    // MARK: - Actions
    
    @IBAction func buttonLogout(_ sender: Any) {
        FirebaseAuthManager.logout()
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
        
    }
    //MARK: - Methods
    
    func setupUI() {
        let name = UserSession.shared.name
        labelName.text = name
        labelInitials.text = name?.getLettersInitiais()
        viewInitials.layer.cornerRadius = 60
        
    }
}
    
