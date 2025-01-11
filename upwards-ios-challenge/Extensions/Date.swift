//
//  Date.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/10/25.
//

import Foundation

extension Date {
    
    init?(iso8601 dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        guard let date = dateStringFormatter.date(from: dateString) else {
            return nil
        }
        self.init(timeInterval:0, since:date)
    }
    
    func inTheLast(
        days: Int,
        today: Date = Date()
    ) -> Bool {
        
        guard let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: today) else {
            return false
        }
        
        return cutoff.timeIntervalSince1970 <= self.timeIntervalSince1970
    }
}
