//
//  JPTabView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import ComposableArchitecture
import SwiftUI

struct JPTabView<Content: View>: View {
    
    @Binding var selectedTab: JPTab
    let action: () -> Void
    private(set) var isLoading: Bool
    let content: Content
    @State private var tabs: [JPTab] = []
    
    init(selectedTab: Binding<JPTab>, action: @escaping () -> Void, isLoading: Bool, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.action = action
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            JPTabBarView(tabs: tabs, selectedTab: $selectedTab, isLoading: isLoading, action: action)
        }
        .onPreferenceChange(JPTabBarPreferenceKey.self) { tabs = $0 }
    }
}

// MARK: - Preview
#Preview {
    JPTabView(selectedTab: .constant(.home), action: {}, isLoading: false) {
        Color.red
    }
}
