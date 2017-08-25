//
//  StringToDate.swift
//  fanspole
//
//  Created by Hardik on 26/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import Foundation

class StringToDate {
    
    func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let dateObj = dateFormatter.date(from: dateString)
        return dateObj!
    }

    func formatStringToDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd' at 'h:mma"
        return dateFormatter.string(from: date)
    }
    
}
