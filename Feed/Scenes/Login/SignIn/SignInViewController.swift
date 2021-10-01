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

        
    }
    // MARK: - Actions
    
    @IBAction func buttonCadastrar(_ sender: Any) {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
        }

    @IBAction func buttonEntry(_ sender: Any) {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                print("==> Error: \(error?.localizedDescription)")
            }
            else {
                print("Usuario Logado")
            }
        }
    }
    
    // MARK: - Methods
    private func setupUI () {
        title = "Fazer login"
        
    }

}
