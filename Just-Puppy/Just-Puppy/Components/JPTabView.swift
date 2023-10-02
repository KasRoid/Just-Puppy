//
//  JPTabView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import SwiftUI

struct JPTabView<Content: View>: View {
    
    @Binding var selectedTab: JPTab
    let content: Content
    @State private var tabs: [JPTab] = []
    
    init(selectedTab: Binding<JPTab>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            JPTabBarView(tabs: tabs, selectedTab: $selectedTab)
        }
        .onPreferenceChange(JPTabBarPreferenceKey.self) { tabs = $0 }
    }
}

// MARK: - Preview
#Preview {
    JPTabView(selectedTab: .constant(.home)) {
        Color.red
    }
}
