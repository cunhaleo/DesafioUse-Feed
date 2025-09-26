//
//  SignUpViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

final class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - Actions
    
    @IBAction func buttonRegister(_ sender: Any) {
        
        guard let name = textFieldName.text,
              let email = textFieldEmail.text,
              let password = textFieldPassword.text,
              let confirmPassword = textFieldConfirmPassword.text
        else { return }
        
        if validateFields(name: name, email: email, password: password, confirmPassword: confirmPassword) {
            Task {
                do {
                    try await FirebaseAuthManager.createAccount(name: name, email: email, password: password)
                    self.showAlert(title: "Sucesso", message: "Cadastro realizado.") {
                        self.openHome()
                    }
                } catch {
                    showAlert(title: "Erro", message: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Methods
     private func validateFields(name: String, email: String, password: String, confirmPassword: String) -> Bool {
        var isValid = true
        
        if password != confirmPassword {
            showAlert(title: "Alerta", message: "Senhas desiguais!")
            isValid = false
        }
        
        if !email.contains("@") {
            showAlert(title: "Alerta", message: "E-mail inválido!")
            isValid = false
        }
        
        if name.count < 2 {
            showAlert(title: "Alerta", message: "Nome inválido!")
            isValid = false
        }
        
        return isValid
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion?()
        })
        alert.addAction(buttonOk)
        present(alert, animated: true)
    }
    func setupUI(){
        title = "Registrar-se"
    }
    
    private func openHome() {
        let viewController = HomeTabViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
}
    
