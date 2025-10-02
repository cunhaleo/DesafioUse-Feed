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
        viewCommentsSection.isHidden = true
    }
    
    func fillComments(_ comments: [Comment]) {
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCommentsSection))
        viewComments.addGestureRecognizer(tapGesture)
        viewComments.isUserInteractionEnabled = true
    }
    
    @objc private func toggleCommentsSection() {
        viewCommentsSection.isHidden.toggle()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
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
