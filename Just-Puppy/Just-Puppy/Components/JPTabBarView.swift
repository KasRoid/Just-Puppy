//
//  JPTabBarView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import SwiftUI

struct JPTabBarView: View {
    
    let tabs: [JPTab]
    @Binding var selectedTab: JPTab
    let action: () -> Void
    
    var body: some View {
        ZStack {
            plusView
            horizontalTabListView
        }
    }
}

// MARK: - UI
extension JPTabBarView {
    
    private var plusView: some View {
        Button(action: { action() }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 14, height: 14)
                .fontWeight(.heavy)
                .padding(16)
                .foregroundStyle(Color.white)
                .background(
                    Circle().fill(Color.mainRed)
                )
        }
    }
    
    private var horizontalTabListView: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                let tab = tabs[index]
                if index == tabs.count / 2 {
                    Spacer().frame(width: 80)
                }
                tabView(for: tab)
                    .contentShape(Rectangle())
                    .onTapGesture { switchToTab(tab) }
            }
        }
    }
    
    private func tabView(for tab: JPTab) -> some View {
        VStack(spacing: 2) {
            Image(systemName: tab.imageName)
                .resizable()
                .frame(width: 16, height: 16)
                .aspectRatio(contentMode: .fit)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Private Functions
extension JPTabBarView {
    
    private func switchToTab(_ tab: JPTab) {
        selectedTab = tab
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        JPTabBarView(tabs: [.home, .favorites, .statistics, .settings], selectedTab: .constant(.home)) {}
    }
}
