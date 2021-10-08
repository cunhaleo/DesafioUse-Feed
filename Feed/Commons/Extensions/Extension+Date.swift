//
//  Extension+Date.swift
//  Feed
//
//  Created by Leonardo Cunha on 05/10/21.
//

import Foundation

public extension Date {
    
    enum DateMask: String {
        case ddMMyyyy = "dd/MM/yyyy"
        case ddMMyyyy_HHmm = "dd/MM/yyyy HH:mm"
        case EEEEasHHmm = "EEEE 'às' HH:mm"
    }
    
    func getDateFormat() -> String? {
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        return format.string(from: self)
    }
    
    func getFormattedDate(format: DateMask) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "pt_BR")
        dateFormat.dateFormat = format.rawValue
        return dateFormat.string(from: self)
    }
    
}
