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
        setupUI()
        
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
    
    func setupUI() {
        labelUserName.text = UserSession.shared.name
        labelInitialsName.text = getLettersInitiais(name: UserSession.shared.name ?? "")
    }
    
    func getLettersInitiais(name: String) -> String {

        let unitaryNames = name.split(separator: " ")

        if let firstName = unitaryNames.first?.description,
           let lastName = unitaryNames.last?.description {

            let char1 = firstName.first?.description ?? ""
            let char2 = lastName.first?.description ?? ""
            return char1.uppercased() + char2.uppercased()
        }
        return "?"
    }
}
