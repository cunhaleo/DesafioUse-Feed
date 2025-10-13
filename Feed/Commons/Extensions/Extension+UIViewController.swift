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
    
    func showProgressScreen() {
        DispatchQueue.main.async {
            let xPosition: CGFloat = UIScreen.main.bounds.midX - 30
            let yPosition: CGFloat = UIScreen.main.bounds.midY - 30
            let frame = CGRect(x: xPosition, y: yPosition, width: 60, height: 60)
            let progress = ProgressView(frame: frame)
            self.view.addSubview(progress)
        }
    }
    
    func dismissProgressScreen() {
        DispatchQueue.main.async {
        for subview in self.view.subviews {
            if subview is ProgressView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
