//
//  Double+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/12/23.
//

import Foundation

extension Double {
    
    var toDecimalPercent: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "%"
    }
}
