//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func buttonLogout(_ sender: Any) {
        FirebaseAuthManager.logout()
        
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
