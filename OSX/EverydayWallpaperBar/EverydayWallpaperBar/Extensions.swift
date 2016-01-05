//
//  Extensions.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 05.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Foundation


// Extensio to create specific date using the NSDate(dateString:"2015-12-15") synthax
extension NSDate
{
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "fr_CH_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
    
    func isToday() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let internalDate = calendar.components([.Era, .Year , .Month , .Day], fromDate: self)
        let compareDate = calendar.components([.Era, .Year , .Month , .Day], fromDate: NSDate())
        
        if internalDate.day == compareDate.day &&
            internalDate.month == compareDate.month &&
            internalDate.year == compareDate.year {
                
                return true
        }
        else {
            return false
        }
    }
}