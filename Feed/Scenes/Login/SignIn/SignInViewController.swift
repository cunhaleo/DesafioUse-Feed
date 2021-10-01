//
//  SignInViewController.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 30/09/21.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    // MARK: - Variables & Attributes
    
    
    // MARK: - Outlets

    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    // MARK: - Actions
    
    @IBAction func buttonCadastrar(_ sender: Any) {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
        }

    @IBAction func buttonEntry(_ sender: Any) {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text else { return }
        
        
        FirebaseAuthManager.signIn(email: email, password: password) { error in
            if error != nil {
                print("==> Error: \(error?.localizedDescription)")
            }
            else {
                let viewController = HomeViewController()
                let navBar = UINavigationController(rootViewController: viewController)
                UIApplication.shared.windows.first?.rootViewController = navBar
                print("Usuario logado")
            }
        }
    }
    
    // MARK: - Methods
    private func setupUI () {
        title = "Fazer login"
        
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .yellow
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }

}
