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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let name = UserSession.shared.name else { return }
        let date = Date()
        let formattedDate = Date().getFormattedDate(format: .EEEEasHHmm).capitalizingFirstLetter()
        
        let newPost = PostModel(message: message,
                                userId: userId,
                                name: name,
                                date: date,
                                formattedDate: formattedDate)
        Task {
            do {
                try await performPost(post: newPost)
            }
            catch {
                print("===> ERROR: \(error.localizedDescription)")
            }
        }
        
    }
    
    // MARK: Methods
    func setupUI() {
        title = "Nova postagem"
        guard let name = UserSession.shared.name else { return }
        let initialLettersName = name.getLettersInitiais()
        
        labelUserName.text = name
        labelInitialsName.text = initialLettersName
        buttonPublish.layer.cornerRadius = 8
        textFieldNewPost.addTarget(self, action: #selector(changePostButtonUI), for: .editingChanged)
    }
    
    @objc func changePostButtonUI () {
        let message = textFieldNewPost.text ?? ""
        let isEnabled = message.count >= 10
        
        buttonPublish.isEnabled = isEnabled
        buttonPublish.backgroundColor = isEnabled ? .systemYellow : .lightGray
        buttonPublish.setTitleColor(.black, for: .normal)
        buttonPublish.setTitleColor(.white, for: .disabled)
    }
    
    private func performPost(post: PostModel) async throws {
        do {
            try await db.collection("Posts").addDocument(data: [
                "message" : post.message,
                "userId" : post.userId,
                "name" : post.name,
                "formattedDate" : post.formattedDate,
                "date" : post.date
            ])
        }
        catch {
            throw error
        }
    }
}
