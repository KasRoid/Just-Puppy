//
//  JPTabBarPreferenceKey.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import SwiftUI

struct JPTabBarPreferenceKey: PreferenceKey {
    
    static var defaultValue: [JPTab] = []
    
    static func reduce(value: inout [JPTab], nextValue: () -> [JPTab]) {
        value += nextValue()
    }
}

struct JPTabBarModifier: ViewModifier {
    
    let tab: JPTab
    @Binding var selectedTab: JPTab
    
    func body(content: Content) -> some View {
        content
            .opacity(selectedTab == tab ? 1 : 0)
            .preference(key: JPTabBarPreferenceKey.self, value: [tab])
    }
}

extension View {
    
    func tabBarItem(_ tab: JPTab, selectedTab: Binding<JPTab>) -> some View {
        modifier(JPTabBarModifier(tab: tab, selectedTab: selectedTab))
    }
}
