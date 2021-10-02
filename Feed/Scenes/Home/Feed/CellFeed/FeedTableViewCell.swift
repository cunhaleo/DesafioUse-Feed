//
//  FeedTableViewCell.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPost: UILabel!
    @IBOutlet weak var labelIniciais: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    func setup(name: String, date: String, post: String) {
        labelUser.text = name
        labelData.text = date
        labelPost.text = post
        labelIniciais.text = getLettersInitiais(name: name)
    }
    
    func getLettersInitiais(name: String) -> String {

        let unitaryNames = name.split(separator: " ")

        if let firstName = unitaryNames.first?.description,
           let lastName = unitaryNames.last?.description {

            let char1 = firstName.first?.description ?? ""
            let char2 = lastName.first?.description ?? ""
            return char1 + char2
        }
        return "?"
    }
}
