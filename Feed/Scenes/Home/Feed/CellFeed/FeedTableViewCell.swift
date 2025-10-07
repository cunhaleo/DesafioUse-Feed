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
    
    
    var didTapComments: (() -> Void)?
    var addNewComment: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCommentsTapGesture()
        setupLikesTapGesture()
        setupNewCommentTextField()
    }
    
    func setup(name: String, date: String, post: String) {
        labelUser.text = name
        labelData.text = date
        labelPost.text = post
        labelIniciais.text = getLettersInitiais(name: name)
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
            self.stackViewMessages.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            
            
            comments.forEach { comment in
                let label = UILabel()
                label.text = "\(comment.userName): \(comment.message)"
                self.stackViewMessages.addArrangedSubview(label)
            }
        }
        
        DispatchQueue.main.async {
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
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
        textField.resignFirstResponder()
        return true
    }
}
