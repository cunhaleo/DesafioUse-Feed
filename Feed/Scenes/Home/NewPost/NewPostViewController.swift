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
    
    // MARK: Outlets
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelInitialsName: UILabel!
    @IBOutlet weak var textFieldNewPost: UITextField!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Actions
    @IBAction func handlerButtonPublish(_ sender: Any) {
        let message = textFieldNewPost.text ?? ""
        let userId = Auth.auth().currentUser?.uid
        let date = Date().getFormattedDate(format: .EEEEasHHmm).capitalizingFirstLetter()

        guard message.count > 10 else { return }
        
        db.collection("Posts").addDocument(data: [
            "message" : message,
            "userId" : userId,
            "name" : UserSession.shared.name,
            "date" : date
        
        ]) { (error) in
            if error != nil {
                print(error)
            } else {
                self.textFieldNewPost.text = ""
            }
        }
        
    }
    
    // MARK: Methods 
    func setupUI() {
        guard let name = UserSession.shared.name else {return}
        let initialLettersName = name.getLettersInitiais()
        
        labelUserName.text = name
        labelInitialsName.text = initialLettersName
    }
}
