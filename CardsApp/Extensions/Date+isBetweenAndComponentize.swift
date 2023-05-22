//
//  Date+isBetweenAndComponentize.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 22.05.2023.
//

import UIKit

extension Date {
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func componentize() -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.day, .month, .year], from: self)
    }
}
