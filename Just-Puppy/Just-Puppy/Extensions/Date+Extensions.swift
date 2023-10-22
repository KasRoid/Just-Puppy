//
//  Date+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/22/23.
//

import Foundation

extension Date {
    func yyyyMMddHHmmss(with timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    var yyyyMMdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var yyyyMMddDashed: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var yyyyMMddHHmmssNoSeperator: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
