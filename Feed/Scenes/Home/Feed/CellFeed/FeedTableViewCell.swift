//
//  FeedTableViewCell.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

final class FeedTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var labelPost: UILabel!
    @IBOutlet weak var labelIniciais: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var stackViewComments: UIStackView!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var viewLikes: UIView!
    @IBOutlet weak var viewCommentsSection: UIView!
    @IBOutlet weak var textFieldNewComment: UITextField!
    @IBOutlet weak var stackViewMessages: UIStackView!
    
    private var post: PostModel?
    
    var didTapComments: (() -> Void)?
    var addNewComment: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCommentsTapGesture()
        setupLikesTapGesture()
        setupNewCommentTextField()
    }
    
    func setup(post: PostModel) {
        self.post = post
        labelUser.text = post.name
        labelData.text = post.formattedDate
        labelPost.text = post.message
        labelIniciais.text = getLettersInitiais(name: post.name)
        hideComments()
    }
    
    func hideComments() {
        DispatchQueue.main.async {
            self.viewCommentsSection.isHidden = true
            self.stackViewMessages.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
        }
    }
    
    func fillComments(_ comments: [Comment]) {
        
        DispatchQueue.main.async {
            self.viewCommentsSection.isHidden = false
            self.stackViewMessages.isHidden = false
            self.stackViewMessages.distribution = .fill
            self.stackViewMessages.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            
            
            comments.forEach { comment in
                let contentView = UIView()
                contentView.translatesAutoresizingMaskIntoConstraints = false
                
                let labelName = UILabel()
                labelName.translatesAutoresizingMaskIntoConstraints = false
                labelName.text = "\(comment.userName) : "
                labelName.font = .systemFont(ofSize: 15, weight: .semibold)
                
                let labelMessage = UILabel()
                labelMessage.translatesAutoresizingMaskIntoConstraints = false
                labelMessage.text = comment.message
                labelMessage.font = .systemFont(ofSize: 14, weight: .regular)
                labelMessage.numberOfLines = 0
                labelMessage.setContentHuggingPriority(UILayoutPriority(751), for: .vertical)
                
                contentView.addSubview(labelName)
                contentView.addSubview(labelMessage)
                self.stackViewMessages.addArrangedSubview(contentView)
                
                NSLayoutConstraint.activate([
                    labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                    labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                    
                    labelMessage.leadingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: 8),
                    labelMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                    labelMessage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    labelMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                    
                    
                    contentView.widthAnchor.constraint(equalTo: self.stackViewMessages.widthAnchor),
                    contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30) ,
                    
                    contentView.leadingAnchor.constraint(equalTo: self.stackViewMessages.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: self.stackViewMessages.trailingAnchor)
                ])
                
            }
        }
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
    
    private func setupLikesTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLikesSection))
        viewLikes.addGestureRecognizer(tapGesture)
        viewLikes.isUserInteractionEnabled = true
    }
    
    @objc private func toggleLikesSection() {
        
    }
    
    private func setupCommentsTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCommentsSection))
        viewComments.addGestureRecognizer(tapGesture)
        viewComments.isUserInteractionEnabled = true
    }
    
    @objc private func tappedCommentsSection() {
        didTapComments?()
    }
    
    private func setupNewCommentTextField() {
        textFieldNewComment.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let newComment = textField.text, !newComment.isEmpty {
            addNewComment?(newComment)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
