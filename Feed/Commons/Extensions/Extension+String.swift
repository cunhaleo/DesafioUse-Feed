//
//  Extension+String.swift
//  Feed
//
//  Created by Leonardo Cunha on 05/10/21.
//

import Foundation

public extension String {

    func getLettersInitiais() -> String {
        
        let unitaryNames = self.split(separator: " ")
        
        if let firstName = unitaryNames.first?.description,
           let lastName = unitaryNames.last?.description {
            
            let char1 = firstName.first?.description ?? ""
            let char2 = lastName.first?.description ?? ""
            
            return char1.uppercased() + char2.uppercased()
        }
        return "?"
    }
    
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized+dropFirst()
    }
}
