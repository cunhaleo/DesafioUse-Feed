//
//  SignInViewController.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 30/09/21.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UINavigationControllerDelegate {
    
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
                self.showAlert(title: "Erro", message: "Login inválido!")
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
        navigationController?.delegate = self
        self.navigationController?.navigationBar.barTintColor = .systemYellow
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
    
  
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(buttonOk)
        present(alert, animated: true, completion: nil)
        }
        

}
