//
//  String+toDate.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

extension String {
    /// Converts a `String` into `Date`. Format should be "MM/dd/yyyy.
    ///
    /// - Returns: An optional `Date` if the convertion succeed.
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "FR")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
    
    /// Converts a `String` into `Date`. Format should be "HH:mm.
    ///
    /// - Returns: An optional `Date` if the convertion succeed.
    func toHour() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "FR")
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}
