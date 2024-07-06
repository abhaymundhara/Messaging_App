//
//  Date+Extension.swift
//  WhatsappDummy
//
//  Created by abhay mundhara on 07/06/2024.
//

import Foundation

extension Date {
    
    /// if today: 3:30 PM
    /// if yesterday returns Yesterday
    /// 02/15/24
    var dayOrTimeRepresentation: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
            
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    /// 3:30 PM
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: self)
        return formattedTime
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var relativeDatetoString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return("Today")
        }
        else if calendar.isDateInYesterday(self) {
            return("Yesterday")
        }
        else if isCurrentWeek {
            return toString(format: "EEEE") //Monday
        }
        else if isCurrentYear {
            return toString(format: "E, MMM d") //Monday, May 29
        }
        else {
            return toString(format: "MMM dd, yyyy") // May 29, 2024
        }
    }
    
    private var isCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekday)
    }
    
    private var isCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}

