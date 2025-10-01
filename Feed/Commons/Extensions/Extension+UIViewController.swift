//
//  Extension+UIViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, onDismiss: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default) { _ in
            onDismiss?()
        }
        alert.addAction(buttonOk)
        present(alert, animated: true, completion: nil)
    }
}
