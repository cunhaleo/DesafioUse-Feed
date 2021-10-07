//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewInitials: UIView!
    
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
        let nome = UserSession.shared.name
        title = "Perfil"
        labelName.text = nome
        labelInitials.text = nome?.getLettersInitiais()
        viewInitials.layer.cornerRadius = 60
        
    }

}
    
