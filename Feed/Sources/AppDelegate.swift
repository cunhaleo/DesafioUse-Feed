//
//  AppDelegate.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 30/09/21.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        setupRootViewController()
      
        return true
    }
        private func setupRootViewController() {
            var viewController: UIViewController = SignInViewController()
            
            if Auth.auth().currentUser != nil {
                viewController = HomeTabViewController()
            }
            
            let navBar = UINavigationController(rootViewController: viewController)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navBar
            window?.makeKeyAndVisible()
        }

}



