//
//  UIColor+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import UIKit

extension UIColor {
    
    public static var mainRed: UIColor { fetchColor(#function) }

    private static func fetchColor(_ name: String) -> UIColor {
        return UIColor(named: name) ?? .clear
    }
}
