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
                self.openHome()
            }
        }
    }
    
    // MARK: - Methods
    private func setupUI () {
        title = "Fazer login"
        
    }
    
    private func openHome() {
        let viewController = HomeTabViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
        
    }
    
    func setupNavigation() {
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.backgroundColor = .systemYellow
            UINavigationBar.appearance().standardAppearance = appearance;
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

        }
        
        navigationController?.navigationBar.barTintColor = .systemYellow
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(buttonOk)
        present(alert, animated: true, completion: nil)
        }
        

}
