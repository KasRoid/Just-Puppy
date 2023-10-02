//
//  Color+Extensions.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import SwiftUI

extension Color {
    
    public static var mainRed: Color { fetchColor(#function) }

    private static func fetchColor(_ name: String) -> Color {
        guard let uiColor = UIColor(named: name) else {
            assertionFailure()
            return .clear
        }
        return Color(uiColor: uiColor)
    }
}
