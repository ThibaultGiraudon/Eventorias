//
//  Date+getDay.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 24/07/2025.
//

import Foundation

extension Date {
    func getDay() -> Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date ?? .now
    }
    
}
