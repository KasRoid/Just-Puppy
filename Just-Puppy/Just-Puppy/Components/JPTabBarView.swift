//
//  JPTabBarView.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import ComposableArchitecture
import SwiftUI

struct JPTabBarView: View {
    
    let tabs: [JPTab]
    @Binding var selectedTab: JPTab
    private(set) var isLoading: Bool
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
            if isLoading {
                ProgressView()
                    .tint(Color.white)
            } else {
                Image(systemName: "plus")
                    .resizable()
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.white)
            }
        }
        .frame(width: 14, height: 14)
        .padding(16)
        .disabled(isLoading)
        .background(
            Circle().fill(isLoading ? Color.gray : Color.mainRed)
        )
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
        .foregroundStyle(isSelected(tab) ? .mainRed : Color.primary)
    }
}

// MARK: - Private Functions
extension JPTabBarView {
    
    private func isSelected(_ tab: JPTab) -> Bool {
        selectedTab == tab
    }
    
    private func switchToTab(_ tab: JPTab) {
        selectedTab = tab
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        JPTabBarView(tabs: [.home, .favorites, .statistics, .settings], selectedTab: .constant(.home), isLoading: true) {}
    }
}
