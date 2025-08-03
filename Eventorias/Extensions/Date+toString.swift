//
//  Date+toString.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

extension Date {
    /// Converts a `Date` to `String`
    ///
    /// - Parameter format: A `String` representing the format into converts the date.
    /// - Returns: A `String` equal at the initial date.
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
}
