//
//  ProgressView.swift
//  Feed
//
//  Created by Leonardo Cunha on 08/10/25.
//

import UIKit

final class ProgressView: UIView {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        precondition(Thread.isMainThread, "UIActivityIndicatorView must be created on the main thread.")
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    override init(frame: CGRect) {
        precondition(Thread.isMainThread, "ProgressView must be initialized on the main thread.")
        super.init(frame: frame)
        buildLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        precondition(Thread.isMainThread, "ProgressView must be initialized on the main thread.")
        super.init(coder: coder)
        buildLayout()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .black
        alpha = 0.4
        if Thread.isMainThread {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        }
    }
    
    private func buildLayout() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
