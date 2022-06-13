//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/1/21.
//

import Foundation

public extension Date {
    init(date: NSDate) {
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
    
    func toString(dateFormat format: String? = "dd.MM.yyyy - HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
