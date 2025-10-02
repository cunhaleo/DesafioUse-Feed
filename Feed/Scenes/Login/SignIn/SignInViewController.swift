//
//  SignInViewController.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 30/09/21.
//

import UIKit
import FirebaseAuth

final class SignInViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func buttonCadastrar(_ sender: Any) {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buttonEntry(_ sender: Any) {
        tappedLogin()
    }
    
    // MARK: - Methods
    private func tappedLogin() {
        guard let email = textFieldEmail.text,
              let password = textFieldPassword.text else { return }
        
        Task {
            do {
                try await FirebaseAuthManager.signIn(email: email, password: password)
                self.openHome()
            }
            catch  {
                self.showAlert(title: "Erro", message: error.localizedDescription)
            }
        }
    }
    
    private func setupUI () {
        title = "Fazer login"
    }
    
    @MainActor private func openHome() {
        let viewController = HomeTabViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
}
