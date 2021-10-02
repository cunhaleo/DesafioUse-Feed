//
//  NewPostViewController.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 01/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewPostViewController: UIViewController {
    // MARK: - Variables & Attributes
    private let db = Firestore.firestore()
    
    // MARK: - Outlets
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelInitialsName: UILabel!
    @IBOutlet weak var textFieldNewPost: UITextField!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Actions
    
    @IBAction func handlerButtonPublish(_ sender: Any) {
        let message = textFieldNewPost.text ?? ""
        let userId = Auth.auth().currentUser?.uid
        
        guard message.count > 10 else { return }
        
        db.collection("Posts").addDocument(data: [
            "message" : message,
            "userId" : userId
        ]) { (error) in
            if error != nil {
                print(error)
            } else {
                self.textFieldNewPost.text = ""
            }
        }
        
    }
    
    
    // MARK: - Methods

    
}
