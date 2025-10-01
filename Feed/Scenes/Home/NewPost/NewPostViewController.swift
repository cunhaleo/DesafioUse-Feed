//
//  NewPostViewController.swift
//  Feed
//
//  Created by Natália Carolina Dos Santos on 01/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class NewPostViewController: UIViewController {
    // MARK: - Variables & Attributes
    private let db = Firestore.firestore()
    
    // MARK: Outlets
    @IBOutlet weak var textViewNewPost: UITextView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelInitialsName: UILabel!
    @IBOutlet weak var buttonPublish: UIButton!
    
    private let placeholderText = "O que você está pensando hoje?"
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Nova Publicação"
    }
    
    // MARK: Actions
    @IBAction func handlerButtonPublish(_ sender: Any) {
        let message = textViewNewPost.text ?? ""
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
                print("===> ERROR: \(error.localizedDescription)") //TODO: ERROR HANDLER
            }
        }
        
    }
    
    // MARK: Methods
    func setupUI() {
        guard let name = UserSession.shared.name else { return }
        let initialLettersName = name.getLettersInitiais()
        labelUserName.text = name
        labelInitialsName.text = initialLettersName
        buttonPublish.layer.cornerRadius = 8
        setupTextView()

    }
    
    private func setupTextView() {
        textViewNewPost.text = placeholderText
        textViewNewPost.textColor = .lightGray
        textViewNewPost.layer.masksToBounds = true
        textViewNewPost.layer.cornerRadius = 8
        textViewNewPost.layer.borderWidth = 1
        textViewNewPost.layer.borderColor = UIColor.lightGray.cgColor
        textViewNewPost.delegate = self
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

extension NewPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changePostButtonUI()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearPlaceholder()
    }
    
    private func clearPlaceholder() {
        if textViewNewPost.textColor == .lightGray {
            textViewNewPost.text = ""
            textViewNewPost.textColor = .label
        }
    }
    
    private func changePostButtonUI() {
        let message = textViewNewPost.text ?? ""
        let isEnabled = message.count >= 10
        
        buttonPublish.isEnabled = isEnabled
        buttonPublish.backgroundColor = isEnabled ? AssetsManager.colorPrimary : .lightGray
        buttonPublish.setTitleColor(.black, for: .normal)
        buttonPublish.setTitleColor(.white, for: .disabled)
    }
}
