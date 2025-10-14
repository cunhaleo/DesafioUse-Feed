//
//  ProfileSubjectCell.swift
//  Feed
//
//  Created by Leonardo Cunha on 14/10/25.
//

import UIKit

final class ProfileSubjectCell: UITableViewCell {
    
    static let identifier: String = "ProfileSubjectCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let unfollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deixar de seguir", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
  // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(subject: String) {
        self.label.text = subject
    }
    
    private func createCell() {
        contentView.addSubview(label)
        contentView.addSubview(unfollowButton)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: unfollowButton.leadingAnchor, constant: 5),
            
            unfollowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unfollowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
            
                                    ])
    }
}



