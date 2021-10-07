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
    @IBOutlet weak var buttonPublish: UIButton!
    
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
        
        buttonPublish.backgroundColor = .lightGray
        buttonPublish.titleLabel?.textColor = .white
        
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
        self.tabBarController?.title = "Nova postagem"
        guard let name = UserSession.shared.name else {return}
        let initialLettersName = name.getLettersInitiais()
        
        labelUserName.text = name
        labelInitialsName.text = initialLettersName
        textFieldNewPost.addTarget(self, action: #selector(textFieldIsReady), for: .editingChanged)
    }
    
    @objc func textFieldIsReady () {
        let message = textFieldNewPost.text ?? ""
        
        if message.count >= 10 {
            buttonPublish.backgroundColor = .systemYellow
            buttonPublish.titleLabel?.textColor = .black
        }
        else{
            buttonPublish.backgroundColor = .lightGray
            buttonPublish.titleLabel?.textColor = .white
        }
    }
}
