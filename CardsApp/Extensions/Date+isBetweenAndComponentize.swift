//
//  Date+isBetweenAndComponentize.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 22.05.2023.
//

import UIKit

struct Components: Comparable {
    let day: Int
    let month: Int
    let year: Int
    
    init?(date: DateComponents) {
        guard date.day != nil, date.month != nil, date.year != nil else { return nil }
        day = date.day!
        month = date.month!
        year = date.year!
        
    }
    
    static func < (lhs: Components, rhs: Components) -> Bool {
        guard lhs.year == rhs.year else {
            if lhs.year < rhs.year {
                return true
            } else {
                return false
            }
        }
        
        guard lhs.month == rhs.month else {
            if lhs.month < rhs.month {
                return true
            } else {
                return false
            }
        }
        
        if lhs.day < rhs.day {
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: Components, rhs: Components) -> Bool {
        if lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day {
            return true
        } else {
            return false
        }
    }
    
    static func > (lhs: Components, rhs: Components) -> Bool {
        guard lhs.year == rhs.year else {
            if lhs.year > rhs.year {
                return true
            } else {
                return false
            }
        }
        
        guard lhs.month == rhs.month else {
            if lhs.month > rhs.month {
                return true
            } else {
                return false
            }
        }
        
        if lhs.day > rhs.day {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func componentize() -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.month, .day, .year], from: self)
    }
    
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        let minDate = Components(date: date1.componentize())
        let maxDate = Components(date: date2.componentize())
        let todayDate = Components(date: self.componentize())
        
        guard let minDate = minDate, let maxDate = maxDate, let todayDate = todayDate else { return false }
        
        if todayDate >= minDate && todayDate <= maxDate {
            return true
        } else {
            return false
        }
    }
    
    func isLonger(_ date: Date) -> Bool {
        let date = Components(date: date.componentize())
        let todayDate = Components(date: self.componentize())
        
        guard let date = date, let todayDate = todayDate else { return false }
        
        if todayDate > date {
            return true
        } else {
            return false
        }
    }
}
